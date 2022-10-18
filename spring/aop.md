Aspect Oriented Programming)
IoC让相互协作的组件保持松散的耦合，而AOP编程允许你把遍布于应用各层的功能分离出来形成可重用的功能组件。

# aop实现有哪几种实现
https://blog.csdn.net/csujiangyu/article/details/53455094

- 静态AOP
在编译期，切面直接以字节 码的形式编译到目标字节 码文件中。

AspectJ属于静态AOP，是在编译时进行增强，会在编译的时候将AOP逻辑织入到代码中，需要专有的编译器和织入器。

优点：被织入的类性能不受影响。
缺点：不够灵活

- 动态AOP  

1)JDK动态代理

在运行期，目标类加载后，为接口动态生成代理类，将切面植入到代理类中。
  
Java从1.3引入动态代理。实现原理是为被代理的业务接口生成代理类，将AOP逻辑写入到代理类中，在运行时动态织入AOP，使用反射执行织入的逻辑。
 
主要实现方式依赖java.lang.reflect包下的InvocationHandler和[Proxy](https://link.juejin.cn/?target=http%3A%2F%2Fwww.liuhaihua.cn%2Farchives%2Ftag%2Fproxy)类。

  
优点：Java标准库原生支持，使用简单，无需引用额外的包。相对于静态AOP更灵活。
缺点：带代理的类必须是接口，灵活性受到一些限制；使用反射会影响一些性能。

2)动态代码字节生成 Code Generation Library
CGLIB，是一个代码生成的类库，通过动态地对目标对象进行子类化来实现AOP代理，可以在运行时动态的生成某个类的子类。

如果目标类没有实现接口，Spring AOP会选择使用CGLIB来动态代理目标类。

在运行期，目标类加载后，动态构建字节码文件生成目标类的子类，将切面逻辑加入到子类中。

CGLib是动态代码字节生成的实现，它封装字节码生成工具Asm，原理是在运行期间目标字节码加载后，生成目标类的子类，将切面逻辑加入到子类中，所以使用Cglib实现AOP不需要基于接口。

优点：没有接口也可以织入，灵活性高。
缺点：扩展类的实例方法为final时，则无法进行织入。

注意，CGLIB是通过继承的方式做的动态代理，因此如果某个类被标记为`final`，那么它是无法使用CGLIB做动态代理的。

## 接口代理和类代理会有什么区别
https://blog.csdn.net/xwh9004/article/details/74103660

CDPlayer是实现了MediaPlayer接口的缘故，此时Spring默认是采用jdk的接口代理模式，代理返回的代理是一个接口。

MyBean未实现任何接口，spring采用CGLIBl类代理模式，当bean实现了接口，spring默认采用jdk的接口代理，当设置proxyTargetClass=true时，spring采用cglib类代理。

# Spring内部创建代理对象的过程
在Spring的底层，如果我们配置了代理模式，Spring会为每一个Bean创建一个对应的ProxyFactoryBean的FactoryBean来创建某个对象的代理对象。
通过JDK的针对接口的动态代理模式。
ProxyFactoryBean提供了如下信息：
1). Proxy应该感兴趣的Adivce列表；
2). 真正的实例对象引用ticketService;
3).告诉ProxyFactoryBean使用基于接口实现的JDK动态代理机制实现proxy: 
4). Proxy应该具备的Interface接口：TicketService;
根据这些信息，ProxyFactoryBean就能给我们提供我们想要的Proxy对象了！

https://blog.csdn.net/luanlouis/article/details/51155821

# 在Spring中的AOP有6种增强方式（Spring支持哪几种切片）

1、Before 前置增强
我们进行一些其它的业务操作，比如校验参数是否为空

2、After 后置增强
可以在方法运行之后进行一些逻辑处理，即连接点返回结果或者抛出异常后（即使程序抛出异常了，后置增强一样会执行），用于打印一个日志告知当前方法运行结束。

3、Around 环绕增强
环绕增强是在调用业务方法之前和调用业务方法之后都可以执行响应的增强语法，也就是说：一个前置增强和一个后置增强相当于是组成了一个环绕增强；

不同的是，在前置增强和后置增强中，在AOP中前置增强和后置增强只能拿到JoinPoint类，而在环绕增强中，可以拿到ProceedingJoinPoint类。
ProceedingJoinPoint类扩展了JoinPoint类的方法，ProceedingJoinPoint可以调用业务方法执行业务逻辑，而JoinPoint则不可以。
可以通过环绕增强实现数据库事务的实现，也可以通过环绕增强实现程序运行时间的记录。

4、AfterReturning 最终增强
后置增强有一点类似，但如果抛异常则不会执行。

5、AfterThrowing 异常增强
在业务方法调用是程序出现异常并且异常在没有被捕获的前提下所触发的。

6、DeclareParents 引入增强

// 前置增强
try {
    // TODO 业务方法
    // 最终增强
}catch (Exception e){
    e.printStackTrace();
    // 异常增强
}finally {
    // 后置增强
}
 Around --> Before --> Around --> After --> AfterReturning --> AfterThrowing 
 所谓引入增强，引入增强和前面的四种增强方式不同，引入增强是基于类上的，前面四种增强是基于方法的。引入增强可以对类添加一些新的方法和属性。

