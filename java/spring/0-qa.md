[查漏补缺1](https://blog.csdn.net/v123411739/article/details/110009966)  
[查漏补缺2](https://developer.aliyun.com/article/619388)
#Spring框架主要有7个模块

1.Spring AOP：面向切面编程思想，同时也提供了事务管理。

2.Spring ORM：提供了对Hibernate、myBatis的支持。

3.Spring DAO：提供了 对Data Access Object模式和JDBC的支持。实现业务逻辑与数据库访问代码分离，降低代码耦合度。

4.Spring Web：提供了Servlet监听器的Context和Web应用的上下文。

5.Spring Context：提供了Spring上下文环境，以及其他如国际化、Email等服务。

6.Spring MVC：提供了MVC设计模式的实现。

7.Spring core：提供了Spring框架基本功能（IOC功能），如BeanFactory以工厂模式创建所需对象、通过读取xml文件实例化对象、管理组件生命周期等。

# 优点
- 方便解耦，简化开发：Spring就是一个大工厂，可以将所有对象的创建和依赖关系的维护，交给Spring管理。
- AOP编程的支持：Spring提供面向切面编程，可以方便的实现对程序进行权限拦截、运行监控等功能。
- 声明式事务的支持：只需要通过配置就可以完成对事务的管理，而无需手动编程。
- 方便程序的测试：Spring对Junit4支持，可以通过注解方便的测试Spring程序。
- 方便集成各种优秀框架：Spring不排斥各种优秀的开源框架，其内部提供了对各种优秀框架的直接支持（如：Struts、Hibernate、MyBatis等）。
- 降低JavaEE API的使用难度：Spring对JavaEE开发中非常难用的一些API（JDBC、JavaMail、远程调用等），都提供了封装，使这些API应用难度大大降低。

# 缺点
- Spring依赖反射，反射影响性能
- 使用门槛升高，入门Spring需要较长时间

# Spring使用了哪些设计模式
- 工厂模式：Spring使用工厂模式通过 BeanFactory、ApplicationContext 创建 bean 对象；
- 代理模式：Spring的AOP功能用到了JDK的动态代理和CGLIB字节码生成技术；
- 单例模式：Bean默认为单例模式。
- 模板方法：用来解决代码重复的问题。如JdbcTemplate，RestTemplate, JmsTemplate, JpaTemplate 等以 Template 结尾的。
- 观察者模式：定义对象键一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都会得到通知被制动更新，如Spring中listener的实现–ApplicationListener。
- 适配器模式 :Spring AOP 的增强或通知(Advice)使用到了适配器模式、spring MVC 中也是用到了适配器模式适配Controller。

[参考](https://mp.weixin.qq.com/s?__biz=Mzg2OTA0Njk0OA==&mid=2247485303&idx=1&sn=9e4626a1e3f001f9b0d84a6fa0cff04a&chksm=cea248bcf9d5c1aaf48b67cc52bac74eb29d6037848d6cf213b0e5466f2d1fda970db700ba41&token=255050878&lang=zh_CN#rd)

# Spring如何处理线程并发问题

在一般情况下，只有无状态的Bean才可以在多线程环境下共享，在Spring中，绝大部分Bean都可以声明为singleton作用域，因为Spring对一些Bean中非线程安全状态采用ThreadLocal进行处理，解决线程安全问题。

ThreadLocal和线程同步机制都是为了解决多线程中相同变量的访问冲突问题。同步机制采用了“时间换空间”的方式，仅提供一份变量，不同的线程在访问前需要获取锁，没获得锁的线程则需要排队。而ThreadLocal采用了“空间换时间”的方式。

ThreadLocal会为每一个线程提供一个独立的变量副本，从而隔离了多个线程对数据的访问冲突。因为每一个线程都拥有自己的变量副本，从而也就没有必要对该变量进行同步了。ThreadLocal提供了线程安全的共享对象，在编写多线程代码时，可以把不安全的变量封装进ThreadLocal。


# Spring事件————ApplicationEvent的使用场景
[demo](https://blog.csdn.net/qwe6112071/article/details/50966660)

# 资料
https://docs.spring.io/spring-framework/docs
