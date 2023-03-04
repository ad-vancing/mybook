[分布式服务框架dubbo 原理](https://blog.csdn.net/xiaoliuliu2050/article/details/55259307)  

[dubbo 的工作原（面试）理](https://github.com/doocs/advanced-java/blob/master/docs/distributed-system/dubbo-operating-principle.md)

[使用](https://blog.csdn.net/u010297957/article/details/51702076)  
http://vence.github.io/2018/03/30/dubbo-info/
https://louluan.blog.csdn.net/article/details/19557465?spm=1001.2014.3001.5502

# RMI（Remote Method Invocation）与代理模式
远程方法调用是一种计算机之间利用远程对象互相调用实现双方通讯的一种通讯机制。使用这种机制，某一台计算机（即JVM虚拟机）上的对象可以调用另外一台计算机上的对象来获取远程数据。

RMI思路是在客户端安装一个代理（proxy），代理是位于客户端虚拟机中的一个对象，对于客户端对象，看起来就像访问的远程对象一样，客户端代理会使用网络协议与服务器进行通信。
同样的服务端也会有一个代理对象来进行通信的繁琐工作。
![](https://images2017.cnblogs.com/blog/415767/201801/415767-20180112135835176-1270918201.png)

https://www.cnblogs.com/jack-Star/p/8277822.html

# Dubbo的底层实现原理和机制

# 描述一个服务从发布到被消费的详细过程

# Dubbo的服务请求失败怎么处理

# 重连机制会不会造成错误

分布式事务的理解

RMI的几种协议和实现框架

dubbo如何对对象进行序列化，用了哪些序列化方式，这些在分布式项目中对提高应用的处理速度，减少网络开销，都很大帮助。

A) dubbo依赖了zooKeeper，但是万一ZooKeeper宕机了怎么办

B) 如果ZooKeeper假死，客户端对服务端的调用是否会全部下线，如果是该如何避免

C) 如何监控duubo的调用，并做到优雅的客户端无感发布
