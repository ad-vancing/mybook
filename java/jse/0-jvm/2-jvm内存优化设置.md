[内存溢出与泄漏](https://www.zhihu.com/question/40560123)

```
JAVA_OPTS="-server -Xms2048m -Xmx2048m -Xmn512m -Xss256k -XX:PermSize=256m -XX:MaxPermSize=256m -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSParallelRemarkEnabled -XX:CMSInitiatingOccupancyFraction=70 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${SPACEXLOG}/"
cd /usr/local/frame/spacex
nohup java ${JAVA_OPTS} -Dcom.sun.management.jmxremote -Dcom.sun.management.snmp.port=8044 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=8045 -Djava.rmi.server.hostname=$LOCAL_IP  -jar ${SPACEXJAR} > ${SPACEXLOG}/stdout.log 2>&1 &
```

[参考](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html#BABDJJFI)

# JVM内存优化
优化后期望达到以下效果即可：
系统响应时间增快；
JVM回收速度增快同时又不影响系统的响应率；
JVM内存最大化利用；
线程阻塞情况最小化。

>配置思路需要考虑的是 Java 提供的垃圾回收机制。虚拟机的堆大小决定了虚拟机花费在收集垃圾上的时间和频度。收集垃圾能够接受的速度和应用有关，应该通过分析实际的垃圾收集的时间和频率来调整。假如堆的大小很大，那么完全垃圾收集就会很慢，但是频度会降低。假如您把堆的大小和内存的需要一致，完全收集就很快，但是会更加频繁。调整堆大小的的目的是最小化垃圾收集的时间，以在特定的时间内最大化处理客户的请求。在基准测试的时候，为确保最好的性能，要把堆的大小设大，确保垃圾收集不在整个基准测试的过程中出现。
假如系统花费很多的时间收集垃圾，请减小堆大小。一次完全的垃圾收集应该不超过 3-5 秒。假如垃圾收集成为瓶颈，那么需要指定代的大小，检查垃圾收集的周详输出，研究垃圾收集参数对性能的影响。当增加处理器时，记得增加内存，因为分配能够并行进行，而垃圾收集不是并行的。

调优时尽量让对象在新生代GC时被回收、让对象在新生代多存活一段时间和不要创建过大的对象及数组避免直接在旧生代创建对象，
调优手段主要是通过控制堆内存的各个部分的比例和GC策略来实现。

# 运行模式
`-server`： -server 启用jdk 的 server 模式。
Server 模式的特点是启动速度比较慢，但运行时性能和内存管理效率很高，适用于生产环境，在具有 64 位能力的 JDK 环境下默认启用该模式，可以不配置该参数。
client 模式，特点是启动速度比较快，但运行时性能和内存管理效率不高，通常用于客户端应用程序或开发调试，在 32 位环境下直接运行 Java 程序默认启用该模式。

如果没有指定JVM版本，会自动根据OS和硬件环境进行识别。
可以通过 `java -version` 查看运行模式。
如果机器是64位，就不用管了。

## 内存大小设置
`-Xms3550m`：设置JVM heap 初始或最小内存为3550M。默认是物理内存的1/64。
>默认空余堆内存小于40%（`MinHeapFreeRatio`参数可以调整）时，JVM就会增大堆直到-Xmx的最大限制；空余堆内存大于70%（`MaxHeapFreeRatio`参数可以调整）时，JVM会减少堆直到-Xms的最小限制。

`-Xmx3550m`：设置JVM堆最大可用内存为3550M。默认是是物理内存的1/4。
>般建议堆的最大值设置为可用内存的最大值的80%。
如何知道我的 JVM 能够使用最大值，使用 `java -Xmx512M -version` 命令来进行测试，然后逐渐的增大 512 的值,如果执行正常就表示指定的内存大小可用，否则会打印错误信息

**Xms、Xmx 两个值设置相同，可以避免 JVM 反复重新申请内存，导致性能大起大落。**
调整堆大小的的目的是最小化垃圾收集的时间。

`-Xmn2g`：设置新生代 Young Generation（eden+ 2 survivor space)，大小为2G。 1/4 of Xmx
**整个堆大小=年轻代大小 + 年老代大小 + 持久代大小（jdk8已被去掉）**。持久代一般固定大小为64m，所以增大年轻代后，将会减小年老代大小。
此值对系统性能影响较大，Sun官方推荐配置为**整个堆的3/8**。 

`-XX:NewSize`： 设置新生代大小。默认为2M，此值设大可调大新对象区，减少Full GC次数？
`-XX:MaxNewSize`：设置最大的新生代大小，默认是16M。
`-XX:NewRatio=4`:设置年老代与新生代的比值。设置为4，则年老代与新生代所占比值为4：1，新生代占整个堆栈的1/5。一般情况下，不允许该值小于1，即Old要比Yong大。
`-XX:SurvivorRatio=4`：设置年轻代中Eden区与Survivor区的大小比值。设置为4, 8?，则两个Survivor区与一个Eden区的比值为2:4，一个Survivor区占整个年轻代的1/6 
但默认情况下以`-XX:InitialSurivivorRatio`为准，此值默认为8。Eden过大（From/To，频繁GC）或过小（频繁YoungGC）。

>`-XX:PermSize`：设置Perm区的初始大小为16m，默认是物理内存的1/64；在数据量的很大的文件导出时，一定要把这两个值设置上，否则会出现内存溢出的错误。
`-XX:MaxPermSize=16m`：设置Perm区的最大值，默认是32M,建议达到物理内存的1/4。存放的都是jvm初始化时加载器加载的一些类型信息（包括类信息、常量、静态变量等），这些信息的生存周期比较长，GC不会在主程序运行期对PermGen Space进行清理，所以如果你的应用中有很多CLASS的话,就很可能出现PermGen Space错误。
上述两个参数值存在于jdk1.7之前，1.8后就没有了。

-XX:OldSize：设置 JVM 启动分配的老年代内存大小，类似于新生代内存的初始大小 -XX:NewSize。

`-Xss128k`：设置每个线程的栈大小。
JDK5.0以后每个线程堆栈大小为1M，以前每个线程堆栈大小为256K。一般小的应用， 如果栈不是很深， 应该是128k够用的，大的应用建议使用256k。
具体应该根据严格的测试进行调整。一般不易设置超过 1M，要不然容易出现out ofmemory。这个选项对性能影响比较大，需要严格的测试。
**在相同物理内存下，减小这个值能生成更多的线程**。但是操作系统对一个进程内的线程数还是有限制的，不能无限生成，经验值在3000~5000左右。

注：32位操作系统，无论你的内存有多大，最大只支持4G内存。

### 持久代/元空间设置（共享内存的非堆区域）
-XX:PermSize=56M：初始分配的持久代容量，默认为物理内存的1/64（从1.8起，该参数已作废，可使用-XX:MetaspaceSize替代）

-XX:MaxPermSize=56M：持久代的最大容量，默认为物理内存的1/4，设置值过小会导致java.lang.OutOfMemoryError: PermGen space错误。（从1.8起，该参数已作废，可使用-XX:MaxMetaspaceSize替代）

-XX:MetaspaceSize=64M：触发FullGC阈值，默认21807104B，约20.8M，而且Metaspace内存容量到达该阈值后，每次扩容都有可能会触发FullGC

-XX:MaxMetaspaceSize=512M：最大元空间大小，默认无限制

## 栈的优化技术——栈帧之间数据的共享
在一般的模型中，两个不同的栈帧的内存区域是独立的，但是大部分的 JVM 在实现中会进行一些优化，使得两个栈帧出现一部分重叠。（主要体现在方法中有参数传递的情况），让下面栈帧的操作数栈和上面栈帧的部分局部变量重叠在一起，这样做不但节约了一部分空间，更加重要的是在进行方法调用时就可以直接公用一部分数据，无需进行额外的参数复制传递了。

## 部分比例不良设置会导致什么后果
1.  新生代设置过小
一是新生代GC次数非常频繁，增大系统消耗；二是导致大对象直接进入旧生代，占据了旧生代剩余空间，诱发Full GC
2.  新生代设置过大
一是新生代设置过大会导致旧生代过小（堆总量一定），从而诱发Full GC；二是新生代GC耗时大幅度增加
一般说来新生代占整个堆1/3比较合适
3.  Survivor设置过小
导致对象从eden直接到达旧生代，降低了在新生代的存活时间
4.  Survivor设置过大
导致eden过小，增加了GC频率
另外，通过-XX:MaxTenuringThreshold=n来控制新生代存活时间，尽量让对象在新生代被回收