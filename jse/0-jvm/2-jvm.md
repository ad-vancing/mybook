《深入理解Java虚拟机》
## jvm是什么
JVM是一种用于计算设备的规范，它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。 负责执行指令，管理数据、内存、寄存器。 不同的平台，有不同的jvm。
https://www.cnblogs.com/pxset/p/11126585.html
https://m.imooc.com/wiki/jvm-jvmframe

## jvm为什么要学习
在高并发情况下，对程序的性能、稳定性、可扩展性方面有较高的要求，提升硬件效能无法等比例地提升程序的运作性能和并发能力，这里有java虚拟机的原因。  

如果开发不了解虚拟机一些技术特性和运行原理，就无法写出最适合虚拟机运行和自优化的代码。

## 跨平台性
![](https://img2020.cnblogs.com/blog/1331583/202003/1331583-20200304162023556-502168582.png)
JVM屏蔽了与具体操作系统平台相关的信息，使Java程序只需生成在Java虚拟机上运行的目标代码（字节码）,就可以在多种平台上不加修改地运行。JVM在执行字节码时，实际上最终还是把字节码解释成具体平台上的机器指令执行。    

# JVM内存结构
内存区（也叫运行时数据区）：是在JVM运行的时候操作所分配的内存区。

线程私有的内存区域有虚拟机栈、本地方法栈、程序计数器；而线程共享的区域有堆、方法区。

![](http://pxset.oss-cn-beijing.aliyuncs.com/blog/jvm-runtime-memory.png)

除了这些，还有一部分内存也被频繁使用，它不是运行时数据区的一部分，也不是Java虚拟机规范中定义的内存区域——**直接内存Direct Memory**或堆外内存。

直接内存的分配不受Java堆大小的限制，但是他还是会受到服务器总内存的影响。可以通过-XX:MaxDirectMemorySize 来限制它的大小（默认与堆内存最大值一样），所以也会出现 OutOfMemoryError 异常。
如果使用了 NIO,这块区域会被频繁使用，在 java 堆内可以用`directByteBuffer`对象直接引用并操作；

其他堆外内存，主要是指使用了 Unsafe 或者其他 JNI 手段直接直接申请的内存。

## 计数器/PC寄存器（Program Counter Register）
每个线程都有一个独立的计数器，可以看作是当前线程所执行的字节码的行号指示器，用来记录线程执行的虚拟机字节码指令。  
1. 字节码解释器工作时通过改变这个计数器的值来选取下一条需要执行的字节码指令，分支、循环、跳转、异常处理、线程恢复等功能都需要依赖这个计数器来完成。  
2. 在多线程的情况下，程序计数器用于记录当前线程执行的位置，从而当线程被切换回来的时候能够知道该线程上次运行到哪儿了。

各线程之间计数器互不影响，独立存储，为“线程私有”的内存。

程序计数器是`唯一一个不会出现 OutOfMemoryError 的内存区域`，它的生命周期随着线程的创建而创建，随着线程的结束而死亡。

ps:如果是Native方法，则计数器中的值为undifined。  
本地方法（native 方法），不是 JVM 来具体执行，在操作系统层面也有一个程序计数器，这个会记录本地代码的执行的地址，所以在执行 native 方法时，JVM 中程序计数器的值为空(Undefined)。


## 虚拟机栈
栈代表了处理逻辑，而堆代表了数据
[为什么要把堆和栈区分出来呢？栈中不是也可以存储数据吗？13年的但可以多看看](https://blog.csdn.net/ithomer/article/details/9936743)
面向对象就是堆和栈的完美结合?
对象的属性其实就是数据，存放在堆中；而对象的行为（方法），就是运行逻辑，放在栈中
为什么不把基本类型放堆中呢？

每个线程创建的同时都会创建JVM栈内存， Java 虚拟机栈描述的是 Java 方法执行的内存模型，每次方法调用的数据都是通过栈传递的。
由一个个栈帧(stack frame)组成，而每个栈帧中都拥有：局部变量表（基本类型变量，非基本类型的对象引用）、操作数栈、动态链接、方法出口信息、部分的返回结果。
每个方法调用会在栈上划出一块作为栈帧。一个方法从开始执行到结束的过程，就是一个栈帧在虚拟机栈中入栈到出栈的过程。  
![](https://img2020.cnblogs.com/blog/1331583/202009/1331583-20200910104748652-1736004103.png)



### 栈的内存溢出
Java 虚拟机栈会出现StackOverFlowError
`StackOverFlowError`： `当线程请求栈的内存大小超过的时候`，就抛出StackOverFlowError异常。
方法无限递归调用时候会出现（栈空间装不下无限进入的栈帧了）。

##  本地方法栈（Native Method Stacks）
JVM采用本地方法堆栈来支持native方法（用 C++ 写的）的执行，此区域用于存储每个native方法调用的状态。
方法执行完毕后相应的栈帧也会出栈并释放内存空间，也会出现 StackOverFlowError 和 OutOfMemoryError 两种错误。

-Xss设置每个线程的栈（stack+native stack）大小

##  堆（Heap）
它是JVM用来存储对象实例以及数组值的区域，可以认为Java中所有通过new创建的对象的内存都在此分配，Heap中的对象的内存需要等待GC进行回收。是垃圾收集器管理的主要区域，因此也被称作`GC堆`。在虚拟机启动时创建。

一个对象创建的时候，到底是在堆上分配，还是在栈上分配呢？
这和两个方面有关：对象的类型和在 Java 类中存在的位置。
Java 的对象可以分为基本数据类型和普通对象。
对于普通对象来说，JVM 会首先在堆上创建对象，然后在其他地方使用的其实是它的引用。比如，把这个引用保存在虚拟机栈的局部变量表中。
对于基本数据类型来说（byte、short、int、long、float、double、char)，有两种情况。
当你在方法体内声明了基本数据类型的对象，它就会在栈上直接分配。其他情况，都是在堆上分配。

Java堆可以处于物理上不连续的内存空间中，只要逻辑上是连续的即可，就像我们的磁盘空间一样。在实现时，既可以实现成固定大小的，也可以是可扩展的，不过当前主流的虚拟机都是按照可扩展来实现的（通过-Xmx和-Xms控制）。

由于现在收集器基本都采用分代垃圾收集算法，所以 Java 堆还可以细分为：新生代和老年代：新生代再细致一点分为：Eden 空间、From Survivor、To Survivor 空间（默认情况下年轻代按照8:1:1的比例来分配）。进一步划分的目的是更好地回收内存，或者更快地分配内存。

大部分情况，对象都会首先在 Eden 区域分配，在一次Eden 区垃圾回收后，如果对象还存活，则会进入 s0 或者 s1(这两个区功能上是交替的)，并且对象的年龄还会加  1(Eden 区->Survivor 区后对象的初始年龄变为 1，s0区的对象经过一次gc后会进入s1，s1区的对象经过一次gc会进入s0)，当它的年龄增加到一定阈值，就会被晋升到老年代中。
>[Hotspot遍历所有对象时，按照年龄从小到大对其所占用的大小进行累积，当累积的某个年龄大小超过了survivor区的一半时，取这个年龄和MaxTenuringThreshold（默认为 15，可以通过参数 `-XX:MaxTenuringThreshold` 来设置）中更小的一个值，作为晋升到老年代的年龄阈值](https://github.com/Snailclimb/JavaGuide/issues/552)。



1）堆是JVM中所有线程共享的，因此在其上进行对象内存的分配均需要进行加锁，这也导致了new对象的开销是比较大的
2） Sun Hotspot JVM为了提升对象内存分配的效率，对于所创建的线程都会分配一块独立的空间TLAB（Thread Local Allocation Buffer），其大小由JVM根据运行的情况计算而得，在TLAB上分配对象时不需要加锁，因此JVM在给线程的对象分配内存时会尽量的在TLAB上分配，在这种情况下JVM中分配对象内存的性能和C基本是一样高效的，但如果对象过大的话则仍然是直接使用堆空间分配
3）TLAB仅作用于新生代的Eden Space，因此在编写Java程序时，通常多个小的对象比大的对象分配起来更加高效。
4）所有新创建的Object 都将会存储在新生代Yong Generation中。如果Young Generation的数据在一次或多次GC后存活下来，那么将被转移到OldGeneration。新的Object总是创建在Eden Space。


### 堆的内存溢出
堆这里最容易出现的就是  OutOfMemoryError 错误，并且出现这种错误之后的表现形式还会有几种，比如：
`OutOfMemoryError: GC Overhead Limit Exceeded` ： 当JVM花太多时间执行垃圾回收并且只能回收很少的堆空间时，就会发生此错误。
`java.lang.OutOfMemoryError: Java heap space` :假如在创建新的对象时, 堆内存中的空间不足以存放新创建的对象, 就会引发java.lang.OutOfMemoryError: Java heap space 错误。(和本机物理内存无关，和你配置的对内存大小有关！)

### 堆的参数控制
-Xms设置堆的最小空间大小；
-Xmx设置堆的最大空间大小；
-XX:NewSize设置新生代最小空间大小；（-Xmn）
-XX:MaxNewSize设置新生代最大空间大小。
-XX:OldSize: 老年代的默认大小, default size of the tenured generation（测试验证JDK1.8.191该参数设置无效，JDK11下设置成功）可以设置堆空间大小和新生代空间大小两个参数来间接控制:老年代空间大小=堆空间大小-年轻代大空间大小。
-XX:NewRatio: 老年代对比新生代的空间大小, 比如2代表老年代空间是新生代的两倍大小. The ratio of old generation to young generation.

将堆的最小值-Xms参数与最大值-Xmx参数设置为一样即可避免堆自动扩展
![](https://img2020.cnblogs.com/blog/1331583/202008/1331583-20200816221419254-745001274.png)
单位：B
与设置的会有一丢丢偏差

##  方法区（Method Area）
存放已被虚拟机加载的类信息（类的名称、版本、修饰符、方法、常量池和Field的引用信息等）、运行时常量池、即时编译器编译后的机器指令等。当开发人员在程序中通过Class对象中的getName、isInterface等方法来获取信息时，这些数据都来源于方法区域，同时方法区域也是全局共享的
注意：（在Java 8 之前），方法区仅是逻辑上的独立区域，在物理上并没有独立于堆而存在，而是`位于永久代PermanetGeneration`中。
java8永久代最终被移除，方法区移至 元空间Metaspace，元空间使用的是直接内存。

[参考](https://mp.weixin.qq.com/s?__biz=MzU4ODM1NjY5NQ==&mid=2247484060&idx=1&sn=a94938bc9ded53ca05faec3070f3f673&chksm=fddf4fa4caa8c6b2c52cde4da0dc97b005215dea62cb7b5ccecfb6f9d91cce639929634a8b3d&cur_album_id=1425209439484870657&scene=189#wechat_redirect
)

>永久代就是 HotSpot 虚拟机对虚拟机规范中方法区的一种实现方式。 
也就是说，永久代是 HotSpot 的概念，方法区是 Java 虚拟机规范中的定义，是一种规范，而永久代是一种实现，一个是标准一个是实现，`其他的虚拟机实现并没有永久代这一说法`。

垃圾收集行为在这个区域是比较少出现的，但并非数据进入方法区后就“永久存在”了。
这个区域的内存回收目标主要是针对常量池的回收和对类型的卸载，一般来说这个区域的回收“成绩”比较难以令人满意，尤其是类型的卸载，条件相当苛刻，但是这部分区域的回收确实是有必要的。

### 为什么要做这个转换？
1、字符串存在永久代中，容易出现性能问题和内存溢出。
2、类及方法的信息等比较难确定其大小，因此对于永久代的大小指定比较困难，太小容易出现永久代溢出，太大则容易导致老年代溢出。
3、永久代会为 GC 带来不必要的复杂度，并且回收效率偏低。
4、Oracle 可能会将HotSpot 与 JRockit 合二为一。

### 相关参数
1.8前：
-XX:PermSize=N //方法区 (永久代) 初始大小
-XX:MaxPermSize=N //方法区 (永久代) 最大大小,超过这个值将会抛出 OutOfMemoryError 异常:java.lang.OutOfMemoryError: PermGen

1.8：
-XX:MetaspaceSize=N //设置 Metaspace 的初始（和最小大小）。如果未指定，Metaspace 将根据运行时的应用程序需求动态地重新调整大小
-XX:MaxMetaspaceSize=N //设置 Metaspace 的最大大小。溢出时会得到如下错误： java.lang.OutOfMemoryError: MetaSpace
默认值为 unlimited，这意味着它只受系统内存的限制，如果不指定大小的话，随着更多类的创建，虚拟机会耗尽所有可用的系统内存。

### 为什么要将永久代 (PermGen) 替换为元空间 (MetaSpace) 呢？
https://www.sczyh30.com/posts/Java/jvm-metaspace/
1、永久代内存经常不够用或发生内存溢出，抛出异常 java.lang.OutOfMemoryError: PermGen。这是因为在 JDK1.7 版本中，指定的 PermGen 区大小为
8M，由于 PermGen 中类的元数据信息在每次 FullGC 的时候都可能被收集，回收率都偏低，成绩很难令人满意；还有为 PermGen 分配多大的空间很难
确定，PermSize 的大小依赖于很多因素，比如，JVM 加载的 class 总数、常量池的大小和方法的大小等。
虽然元空间仍旧可能溢出，但是比原来出现的几率会更小。元空间使用的是直接内存，受本机可用内存非 JVM内存的限制，能加载的类就更多了。
2、可以促进 HotSpot JVM 与 JRockit VM 的融合，因为 JRockit 没有永久代。

### 常量池（Constant Pool Table）
是方法区的一部分。属于类的信息，包括字符串常量池以及所有基本类型都有其相应的常量池。用于存放编译期生成的各**种字面量和符号引用**。
字面量包括字符串（String a=“b”）、基本类型的常量（final 修饰的变量），符号引用则包括类和方法的全限定名（例如 String 这个类，它的全限定名
就是 Java/lang/String）、字段的名称和描述符以及方法的名称和描述符。

#### 符号引用
一个 java 类（假设为 People 类）被编译成一个 class 文件时，如果 People 类引用了 Tool 类，但是在编译时 People 类时并不知道引用类的实际内存地址，因此只能使用符号引用（org.simple.Tool ）来代替。
而在类装载器装载 People 类时，此时可以通过虚拟机获取 Tool 类的实际内存地址，因此便可以既将符号 org.simple.Tool 替换为 Tool 类的实际内存地址，及直接引用地址。
即在编译时用符号引用来代替引用类，在加载时再通过虚拟机获取该引用类的实际地址。以一组符号来描述所引用的目标，符号可以是任何形式的字面量，只要使用时能无歧义地定位到目标即可。符号引用与虚拟机实现的内存布局是无关的，引用的目标不一定已经加载到内存中。 

### 运行时常量池（Runtime Constant Pool）
https://blog.csdn.net/wangbiao007/article/details/78545189
动态常量池里的内容除了是静态常量池（class文件常量池）里的内容外，还将静态常量池里的符号引用转变为直接引用（对象的索引值），而且动态常量池里的内容是能动态添加的。
例如调用String的intern方法就能将string的值添加到String常量池中，这里String常量池是包含在动态常量池里的，**但在jdk1.8后，将String常量池放到了堆中**。

>当类加载到内存后，JVM 就会将 class 文件常量池中的内容存放到运行时常量池中；在解析阶段，JVM 会把符号引用替换为直接引用（对象的索引值）。
eg:类中的一个字符串常量在 class 文件中时，存放在 class 文件常量池中的。
在 JVM 加载完类之后，JVM 会将这个字符串常量放到运行时常量池中，并在解析阶段，指定该字符串对象的索引值。

运行时常量池是全局共享的，多个类共用一个运行时常量池，因此，class 文件中常量池多个相同的字符串在运行时常量池只会存在一份。
```
    public static void main(String[] args) {
        String str = "Hello";
        System.out.println((str == ("Hel" + "lo")));

        String loStr = "lo";
        System.out.println((str == ("Hel" + loStr)));

        System.out.println(str == ("Hel" + loStr).intern());
    }
```
第一个为 true，是因为在编译成 class 文件时，能够识别为同一字符串的, JVM 会将其自动优化成字符串常量,引用自同一 String 对象。
第二个为 false，是因为在运行时创建的字符串具有独立的内存地址,所以不引用自同一 String 对象。
第三个为 true，是因为 String 的 intern() 方法会查找在常量池中是否存在一个相等(调用 equals() 方法结果相等)的字符串,如果有则返回该字符串的引用,如果没有则添加自己的字符串进入常量池。

JDK1.7 及之后版本的 JVM 已经将运行时常量池从方法区中移了出来，在 Java 堆（Heap）中开辟了一块区域存放运行时常量池。
在 JDK1.8 中，使用元空间代替永久代来实现方法区，但是方法区并没有改变，所谓"Your father will always be your father"。变动的只是方法区中内容的物理存放位置，但是运行时常量池和字符串常量池被移动到了堆中。但是不论它们物理上如何存放，逻辑上还是属于方法区的。

>常量池有很多概念，包括运行时常量池、class 常量池、字符串常量池。
虚拟机规范只规定以上区域属于方法区，并没有规定虚拟机厂商的实现。
严格来说是静态常量池和运行时常量池，静态常量池是存放字符串字面量、符号引用以及类和方法的信息，而运行时常量池存放的是运行时一些直接引
用。
运行时常量池是在类加载完成之后，将静态常量池中的符号引用值转存到运行时常量池中，类在解析之后，将符号引用替换成直接引用。
运行时常量池在 JDK1.7 版本之后，就移到堆内存中了，这里指的是物理空间，而逻辑上还是属于方法区（方法区是逻辑分区）。

## 版本变化
1.8前：
![](https://user-gold-cdn.xitu.io/2019/12/15/16f0813a8e3a938a?imageslims)
1.8后：
![](https://user-gold-cdn.xitu.io/2019/12/15/16f0813a8ff2ac5e?imageslim)

# 常见的 Java 内存溢出有以下几种
- java.lang.OutOfMemoryError: Java heap space —-JVM Heap（堆）溢出
假如在创建新的对象时, 堆内存中的空间不足以存放新创建的对象, 就会引发java.lang.OutOfMemoryError: Java heap space 错误。(和本机物理内存无关，和你配置的对内存大小有关！)
JVM 在启动的时候会自动设置 JVM Heap 的值，其初始空间（即-Xms）是物理内存的1/64，最大空间（-Xmx）不可超过物理内存。
解决方法：利用 JVM提供的 -Xms -Xmx 等选项，手动设置 JVM Heap（堆）的大小。  

- java.lang.OutOfMemoryError: GC Overhead Limit Exceeded 
当JVM花太多时间执行垃圾回收并且只能回收很少的堆空间时，就会发生此错误。
“并行/并发回收器在GC回收时间过长时会抛出OutOfMemroyError。用来避免内存过小造成应用不能正常工作。
增加参数，-XX:-UseGCOverheadLimit，可以关闭这个特性，但最好不要，因为解决不了内存问题，只是把错误的信息延后，替换成 java.lang.OutOfMemoryError: Java heap space；2因为它可以在应用挂掉之前做最后的挣扎，比如数据保存或者保存现场（Heap Dump）。
默认情况下，如果Java进程花费98%以上的时间执行GC，并且每次只有不到2%的堆被恢复，则JVM抛出此错误。换句话说，这意味着我们的应用程序几乎耗尽了所有可用内存，垃圾收集器花了太长时间试图清理它，并多次失败。


- java.lang.OutOfMemoryError: PermGen space  —- PermGen space 溢出。
即持久代(Permanent Generation)的内存溢出，jdk8已经没有了。
这块内存主要是被 JVM 存放Class 和 Meta 信息的，Class 在被 Load 的时候被放入该区域，它和存放 Instance 的 Heap 区域不同，sun 的 GC 不会在主程序运行期对 PermGen space 进行清理，所以如果你的 APP 会载入很多 CLASS 的话，就很可能出现 PermGen space 溢出。
这种错误常见在web服务器对JSP进行pre compile的时候。？
解决方法： 手动设置 MaxPermSize 大小
[java.lang.OutOfMemoryError: PermGen space有效解决方法](https://blog.csdn.net/yufang131/article/details/80747564)

- java.lang.StackOverflowError   —- 栈溢出
**每个方法调用会在栈上划出一块作为栈帧。一个方法从开始执行到结束的过程，就是一个栈帧在虚拟机栈中入栈到出栈的过程。**
调用函数的 “层”太多了，栈空间装不下无限进入的栈帧了，以致于把栈区溢出了。
通常来讲，一般栈区远远小于堆区的，因为函数调用过程往往不会多于上千层，而即便每个函数调用需要 1K 的空间（这个大约相当于在一个 C 函数内声明了 256 个 int 类型的变量），那么栈区也不过是需要 1MB 的空间。通常栈的大小是 1－2MB 的。

[更多参考](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/memleaks002.html)

https://cloud.tencent.com/developer/article/1342372
工具使用 https://blog.csdn.net/sinat_33760891/article/details/82425621

待阅读：
https://juejin.im/post/5ea2995851882573c04cef4e
https://juejin.im/post/5df5c76ee51d45581634f256#heading-29
https://www.jianshu.com/p/4455e4234d5c
http://www.spring4all.com/article/18645
https://developer.aliyun.com/article/681512
https://www.infoq.cn/article/rhW0p6VHzOZ1swcd86rW
https://www.yisu.com/zixun/91929.html
https://bbs.huaweicloud.com/blogs/136192
https://juejin.im/post/59da10a76fb9a00a664a5e6e
https://juejin.im/post/5f1e3152f265da22b252a885

# 逃逸分析优化JVM原理