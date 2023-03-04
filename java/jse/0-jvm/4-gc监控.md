## 监控gc参数 VM options
```
-XX:+PrintCommandLineFlags：打印虚拟机默认参数
-XX:+DisableExplicitGC：静止Java程序中的FULL GC，如System.gc()
-XX:+PrintTenuringDistribution：用于显示每次Minor GC（年轻代GC）时Survivor区中各个年龄段的对象的大小
-XX:InitialTenuringThreshol：年轻代对象转换为老年代对象最小年龄值，默认值7，对象在坚持过一次Minor GC之后，年龄就加1
-XX:MaxTenuringThreshold：年轻代对象转换为老年代对象最大年龄值，默认值15
-Xloggc:filename：将GC信息输出到文件，带时间戳（如：-Xloggc:E:\gc.txt，JKD11已过期，新版本使用-Xlog:gc:gc.txt代替，日志内容见下图）
-Xlog:gc：输出GC日志信息（JDK11新增）

-XX:+PrintGCDetails  打印每次gc的回收情况 程序运行结束后打印堆空间内存信息(包含内存溢出的情况)
-XX:+PrintHeapAtGC  打印每次gc前后的内存情况
-XX:+PrintGCTimeStamps 打印每次gc的间隔的时间戳 full gc为每次对新生代老年代以及整个空间做统一的回收 系统中应该尽量避免
-XX:+TraceClassLoading  打印类加载情况
-XX:+PrintClassHistogram 打印每个类的实例的内存占用情况
-Xloggc:/Users/xiaofuge/Desktop/logs/log.log  配合上面的使用将上面的日志打印到指定文件
-XX：HeapDumpOnOutOfMemoryError 发生内存溢出将堆信息转存起来 以便分析


-verbose:gc -XX:+PrintGCDetails
```

# 监视JVM内存使用情况
[具体看这里](https://blog.csdn.net/q975583865/article/details/78199917)

jps -l
jmap –heap PID可用于查看各个内存空间的大小；
![](https://img2018.cnblogs.com/blog/1331583/201905/1331583-20190511043456381-1521625126.png)

也可使用JDK自带的jconsole可以比较明了的看到内存的使用情况，线程的状态，当前加载的类的总量等；

JDK自带的jvisualvm可以下载插件（如GC等），可以查看更丰富的信息。
https://visualvm.github.io/
利用visualvm去查看内存使用量曲线图，如果内存使用量一直维持在较高水平，那就是堆内存不够，需要调大一点。如果频繁发生抖动，那就是程序频繁生成对象并且进行回收，优化代码，保存可重用的对象不要频繁生成。如果内存使用量一直增长，那就是发生内存泄漏或者内存碎片，需要排查代码或者把cms收集器调成gc几次就执行一次标记整理算法来搞定内存碎片（-XX:+UseCMSCompactAtFullCollection、-XX:CMSFullGCsBeforeCompaction）。

如果是分析本地的Tomcat的话，还可以进行内存抽样等，检查每个类的使用情况
[JProfiler是什么](https://www.cnblogs.com/jpfss/p/8488111.html)
https://docs.oracle.com/javase/7/docs/technotes/guides/management/jconsole.html

jinfo -flags pid

## jstat
`jstat –gc pid 2000`
```
S0C、S1C，第一个和第二个幸存区大小
S0U、S1U，第一个和第二个幸存区使用大小
EC、EU，伊甸园的大小和使用
OC、OU，老年代的大小和使用
MC、MU，方法区的大小和使用
CCSC、CCSU，压缩类空间大小和使用
YGC、YGCT，年轻代垃圾回收次数和耗时
FGC、FGCT，老年代垃圾回收次数和耗时
GCT，垃圾回收总耗时
```
### jstack 查看进程中的线程状态
`jstat pid `该进程在查询时刻的线程状态（瞬时态）。

## 其他
**-XX:+HeapDumpOnOutOfMemoryError**：内存溢出时Dump出当前堆内存快照
**-XX:HeapDumpPath=filename**：导出路径（如：-XX:HeapDumpPath=E:/a.dump）
-XX:PretenureSizeThreshold=10240：对象大小超过10KB时直接在年老代分配内存。默认值0，单位字节，表示所有的对象都在年轻代eden区分配
-Duser.timezone=Asia/Shanghai：设置用户所在时区。
-Djava.awt.headless=true：这个参数一般我们都是放在最后使用的，这全参数的作用是这样的，有时我们会在我们的 J2EE 工程中使用一些图表工具如：jfreechart，用于在 web 网页输出 GIF/JPG 等流，在 winodws 环境下，一般我们的 app server 在输出图形时不会碰到什么问题，但是在linux/unix 环境下经常会碰到一个 exception 导致你在 winodws 开发环境下图片显示的好好可是在 linux/unix 下却显示不出来，因此加上这个参数以免避这样的情况出现。



#  -XX:+PrintGC 参数
使用这个参数启动 Java 虚拟机后，只要遇到 GC，就会打印日志。
```
[GC (System.gc())  3933K->792K(251392K), 0.0054898 secs]
[Full GC (System.gc())  792K->730K(251392K), 0.0290579 secs]
```
GC 与 Full GC：表示这次垃圾收集的停顿类型;如果有Full，则说明本次GC停止了其他所有工作线程(Stop-The-World)。
看到Full GC的写法是“Full GC(System)”，这说明是调用System.gc()方法所触发的GC。
                           
3933K->792K(251392K)：代表了之前使用了 3933k 的空间，回收之后使用 792k 空间，言外之意这次垃圾回收节省了 3933k - 792k = 3141k 的容量。
括号里的251392K 代表总容量；
0.0054898 secs：代表了垃圾回收的执行时间，以秒为单位。
792K->730K(251392K)：分析同上；

# -XX:+PrintGCDetails 参数
获取比 -XX:+PrintGC 参数更详细的 GC 信息，把空间清理的部分也表达的更加详细了。
```
[GC (System.gc()) [PSYoungGen: 3933K->792K(76288K)] 3933K->800K(251392K), 0.0034601 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[Full GC (System.gc()) [PSYoungGen: 792K->0K(76288K)] [ParOldGen: 8K->730K(175104K)] 800K->730K(251392K), [Metaspace: 3435K->3435K(1056768K)], 0.0217628 secs] [Times: user=0.03 sys=0.00, real=0.02 secs] 
```
PSYoungGen：代表了「年轻代」的回收
ParOldGen：「老年代」
Metaspace：「元空间」，JDK 的低版本也称之为永久代

>这里显示的区域名称与使用的GC收集器是密切相关的，
如采用Parallel Scavenge收集器，那它配套的新生代称为“PSYoungGen”，老年代和永久代同理，名称也是由收集器决定的。
如使用的Serial收集器，新生代名为“Default New Generation”，所以会显示“[DefNew”。
如果是ParNew收集器，新生代名称就会变为“[ParNew”，意为“Parallel New Generation”。



最后的“[Times: user=0.03 sys=0.00, real=0.02 secs] ”则更具体了，user表示用户态消耗的CPU时间、内核态消耗的CPU时间、操作从开始到结束经过的墙钟时间。
后面两个的区别是，操作时间包括各种非运算的等待消耗，比如等待磁盘I/O、等待线程阻塞，而CPU时间不包括这些耗时，但当系统有多CPU或者多核的话，多线程操作会叠加这些CPU时间，所以如果看到user或sys时间超过real时间是完全正常的。



# -XX:+PrintGCTimeStamps 参数
在每次 GC 发生时，额外输出 GC 发生的时间，该输出时间为虚拟机启动后的时间偏移量。
需要与 -XX:+PrintGC 或 -XX:+PrintGCDetails 配合使用，单独使用 -XX:+PrintGCTimeStamps 参数是没有效果的。
```
0.247: [GC (System.gc())  3933K->760K(251392K), 0.0114098 secs]
0.259: [Full GC (System.gc())  760K->685K(251392K), 0.0079185 secs]
```
与 -XX:+PrintGC 参数打印的结果，唯一的区别就是日志开头的 0.247 与 0.259。此处 0.247 与 0.259 表示， JVM开始运行 0.247 秒后发生了 GC，开始运行 0.259 秒后，发生了 Full GC。

# -XX:+PrintHeapAtGC 参数
在每次 GC 前后分别打印堆的信息
```
{Heap before GC invocations=1 (full 0):
 PSYoungGen      total 76288K, used 3933K [0x000000076b400000, 0x0000000770900000, 0x00000007c0000000)
  eden space 65536K, 6% used [0x000000076b400000,0x000000076b7d7480,0x000000076f400000)
  from space 10752K, 0% used [0x000000076fe80000,0x000000076fe80000,0x0000000770900000)
  to   space 10752K, 0% used [0x000000076f400000,0x000000076f400000,0x000000076fe80000)
 ParOldGen       total 175104K, used 0K [0x00000006c1c00000, 0x00000006cc700000, 0x000000076b400000)
  object space 175104K, 0% used [0x00000006c1c00000,0x00000006c1c00000,0x00000006cc700000)
 Metaspace       used 3420K, capacity 4496K, committed 4864K, reserved 1056768K
  class space    used 371K, capacity 388K, committed 512K, reserved 1048576K
Heap after GC invocations=1 (full 0):
 PSYoungGen      total 76288K, used 792K [0x000000076b400000, 0x0000000770900000, 0x00000007c0000000)
  eden space 65536K, 0% used [0x000000076b400000,0x000000076b400000,0x000000076f400000)
  from space 10752K, 7% used [0x000000076f400000,0x000000076f4c6030,0x000000076fe80000)
  to   space 10752K, 0% used [0x000000076fe80000,0x000000076fe80000,0x0000000770900000)
 ParOldGen       total 175104K, used 0K [0x00000006c1c00000, 0x00000006cc700000, 0x000000076b400000)
  object space 175104K, 0% used [0x00000006c1c00000,0x00000006c1c00000,0x00000006cc700000)
 Metaspace       used 3420K, capacity 4496K, committed 4864K, reserved 1056768K
  class space    used 371K, capacity 388K, committed 512K, reserved 1048576K
}
{Heap before GC invocations=2 (full 1):
 PSYoungGen      total 76288K, used 792K [0x000000076b400000, 0x0000000770900000, 0x00000007c0000000)
  eden space 65536K, 0% used [0x000000076b400000,0x000000076b400000,0x000000076f400000)
  from space 10752K, 7% used [0x000000076f400000,0x000000076f4c6030,0x000000076fe80000)
  to   space 10752K, 0% used [0x000000076fe80000,0x000000076fe80000,0x0000000770900000)
 ParOldGen       total 175104K, used 0K [0x00000006c1c00000, 0x00000006cc700000, 0x000000076b400000)
  object space 175104K, 0% used [0x00000006c1c00000,0x00000006c1c00000,0x00000006cc700000)
 Metaspace       used 3420K, capacity 4496K, committed 4864K, reserved 1056768K
  class space    used 371K, capacity 388K, committed 512K, reserved 1048576K
Heap after GC invocations=2 (full 1):
 PSYoungGen      total 76288K, used 0K [0x000000076b400000, 0x0000000770900000, 0x00000007c0000000)
  eden space 65536K, 0% used [0x000000076b400000,0x000000076b400000,0x000000076f400000)
  from space 10752K, 0% used [0x000000076f400000,0x000000076f400000,0x000000076fe80000)
  to   space 10752K, 0% used [0x000000076fe80000,0x000000076fe80000,0x0000000770900000)
 ParOldGen       total 175104K, used 705K [0x00000006c1c00000, 0x00000006cc700000, 0x000000076b400000)
  object space 175104K, 0% used [0x00000006c1c00000,0x00000006c1cb07a0,0x00000006cc700000)
 Metaspace       used 3420K, capacity 4496K, committed 4864K, reserved 1056768K
  class space    used 371K, capacity 388K, committed 512K, reserved 1048576K
}

```

# oom demo
https://www.cnblogs.com/paddix/p/5309550.html
https://blog.csdn.net/wilsonpeng3/article/details/70064336/
https://www.cnblogs.com/xiaoxi/p/6557473.html
https://cv2ex.com/t/649773#reply11

