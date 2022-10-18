# NIO和IO的主要区别
![](https://img-blog.csdnimg.cn/b7189c1cee1a4ae4a37477c560932e6f.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE3NDA1MTgz,size_16,color_FFFFFF,t_70)
Java NIO的选择器允许一个单独的线程来监视多个输入通道，你可以注册多个通道使用一个选择器，然后使用一个单独的线程来“选择”通道：这些通道里已经有可以处理的输入，或者选择已准备写入的通道。这种选择机制，使得一个单独的线程很容易来管理多个通道。

Java NIO: 单线程管理多个连接
Java IO: 一个典型的IO服务器设计- 一个连接通过一个线程处理.

NIO的优势：
1.优势在于一个线程管理多个通道；但是数据的处理将会变得复杂；
2.如果需要管理同时打开的成千上万个连接，这些连接每次只是发送少量的数据，采用这种；
传统IO的优势：
1.适用于一个线程管理一个通道的情况；因为其中的流数据的读取是阻塞的；
2.如果需要管理同时打开不太多的连接，这些连接会发送大量的数据；





一种基于通道（Channel）与缓冲区（Buffer）的 I/O 方式

https://www.cnblogs.com/czwbig/p/10035631.html

netty的线程模型么？
我：（幸好我看过netty的源码）netty通过Reactor模型基于多路复用器接收并处理用户请求（能讲就多讲一点），内部实现了两个线程池，boss线程池和work线程池，其中boss线程池的线程负责处理请求的accept事件，当接收到accept事件的请求时，把对应的socket封装到一个NioSocketChannel中，并交给work线程池，其中work线程池负责请求的read和write事件

nio中selector可能触发bug么？

我：嗯，对的，selector的select方法，因为底层的epoll函数可能会发生空转，从而导致cpu100%。


# 使用场景
如果管理的是成千上万个连接，但是这些连接每次只是发送少量的数据，例如我们常用的聊天服务器，这时候选择NIO处理数据可能是个很好的选择。


#  I/O 模型
操作系统执行 I/O 指令的方法

主流的 I/O 模型通常有 5 种类型:阻塞式 I/O、非阻塞式 I/O、I/O 多路复用、信号驱动 I/O 和异步 I/O。

每种 I/O 模型都有各自典型的使用场景，比如 Java 中 Socket 对象的阻 塞模式和非阻塞模式就对应于前两种模型;而 Linux 中的系统调用 select 函数就属于 I/O 多路复用模型;大名鼎鼎的 epoll 系统调用则介于第三种和第四种模型之间;至于第五种模 型，其实很少有 Linux 系统支持，反而是 Windows 系统提供了一个叫 IOCP 线程模型属 于这一种。