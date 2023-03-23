《深入理解Linux内核》

# Linux用户态和内核态
https://www.linuxjournal.com/article/7356  
操作系统将线程分为了内核态和用户态，当用户线程调用了系统调用的时候，需要将线程从用户态切换到内核态。

## 用户空间和内核空间
操作系统将内存按1：3的比例分为内核空间和用户空间。

- 内核空间中主要负责 操作系统内核线程以及用户程序系统调用。
- 用户空间主要负责用户程序的非系统调用。  
内核空间比用户空间拥有更高的操作级别，只有在内核空间中才可以调用操作硬件等核心资源。

## 用户态切换到内核态
每个线程都对应着一个用户栈和内核栈，分别用来执行用户方法和内核方法。  
- 用户方法就是普通的操作。   
- 内核方法就是访问磁盘、内存分配、网卡、声卡等敏感操作。  

**当用户尝试调用内核方法的时候**，就会发生用户态切换到内核态的转变。
![图](https://img-blog.csdnimg.cn/4285b066dca247c8a22f98dd6040bb8e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5byg5a2f5rWpX2pheQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

用户态切换到内核态的时候，会牵扯到用户态现场信息的保存以及恢复，还要进行一系列的安全检查，比较耗费资源。

### 切换流程(用户态->内核态->用户态)
1. 用户态进行 cpu上下文切换，包括保存当前运行需要的寄存器状态（从哪开始运行）等，切换进需要的cpu寄存器等
2. 用户态可以直接读写寄存器，用户态操作CPU，将寄存器的状态保存到对应的内存中，然后调用对应的系统函数，传入对应的用户栈的PC地址和寄存器信息，方便后续内核方法调用完毕后，恢复用户方法执行的现场。
3. 将CPU的字段改为内核态，将内核段对应的代码地址写入到PC寄存器中，然后开始执行内核方法，相应的方法栈帧时保存在内核栈中。
4. 当内核方法执行完毕后，会将CPU的字段改为用户态，然后利用之前写入的信息来恢复用户栈的执行。

## “零拷贝”技术（kafka）
“零拷贝”技术使得数据不在经过用户态传输，而是直接在内核态完成操作，减少了两次 copy 操作。从而大大提高了数据传输速度。
![普通数据拷贝流程图](https://mmbiz.qpic.cn/mmbiz_png/uEEVSjtvevZib7OQbVBlQykboGTjNMbSadm2qahu78tK7mtGZ76I8Vgqe0iaMicJCxkgKLJmfeJPAY9OSBsqcIUFQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

!["零拷贝"流程图](https://mmbiz.qpic.cn/mmbiz_png/uEEVSjtvevZib7OQbVBlQykboGTjNMbSaaEus8JsacR6iaCOGbzgsTvamYUKzbaU1HT2B8XlGUKIvWsPI8N1NLcg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

# I/O 模型
[参考](https://blog.csdn.net/m0_38109046/article/details/89449305)  
操作系统执行 I/O 指令的方法  
如网络连接的处理、网络请求的解析，以及数据存取的处理，是用一个线程、多个线程，还是多个进程来交互处理呢？

该如何进行设计和取舍呢？我们一般把这个问题称为I/O模型设计。

主流的 I/O 模型通常有 5 种类型:阻塞式 I/O、非阻塞式 I/O、I/O 多路复用、信号驱动 I/O 和异步 I/O。

每种 I/O 模型都有各自典型的使用场景，比如 Java 中 Socket 对象的阻塞模式和非阻塞模式就对应于前两种模型;而 Linux 中的系统调用 select 函数就属于 I/O 多路复用模型;大名鼎鼎的 epoll 系统调用则介于第三种和第四种模型之间;至于第五种模 型，其实很少有 Linux 系统支持，反而是 Windows 系统提供了一个叫 IOCP 线程模型属 于这一种。

非阻塞式 I/O 准备好数据后还是要阻塞进程去内核读取数据，因此不算异步 I/O。

# 虚拟内存

# 段式、页式、进程调度算法

# Linux的namespace、进程线程、线程通信方式、进程通信方式