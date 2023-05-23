Aspect Oriented Programming  
IoC让相互协作的组件保持松散的耦合，而AOP编程允许你把遍布于应用各层的功能分离出来形成可重用的功能组件。


# aop实现
## 静态AOP  
在编译期，切面直接以字节 码的形式编译到目标字节 码文件中。编译时增强

AspectJ 属于静态 AOP，是在**编译时**进行增强，会在**编译的时候将AOP逻辑织入到代码中**，需要专有的编译器和织入器。

优点：被织入的类性能不受影响。  
缺点：不够灵活

## 动态AOP  
动态就是说 AOP 框架**不会去修改字节码，而是在内存中临时为方法生成一个 AOP 对象**，这个 AOP 对象包含了目标对象的全部方法，并且在特定的切点做了增强处理，并回调原对象的方法。运行时增强
```
public interface BarService {
    void doSomething();
}

public class BarServiceImp implements BarService {
    @Override
    public void doSomething() {
        System.out.println("执行原有业务逻辑...");
    }
}
```
### JDK动态代理
```
public class LogPrintHandler implements InvocationHandler {
    private Object target;

    public LogPrintHandler(Object target) {
        this.target = target;
    }

    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("执行AOP织入的代码!!!");
        Object ret = method.invoke(this.target, args);
        return ret;
    }
}

public class App {
    public static void main(String[] args) {
        BarService service = (BarService) Proxy.newProxyInstance(
                Thread.currentThread().getContextClassLoader(), new Class[]{BarService.class}, new LogPrintHandler(new BarServiceImp()));
        service.doSomething();
    }
}

```

在**运行期**，目标类加载后，**为接口动态生成代理类**，将切面植入到代理类中。
  
主要实现方式依赖 java.lang.reflect 包下的 InvocationHandler 和 Proxy 类。

优点：Java标准库原生支持，使用简单，无需引用额外的包。相对于静态AOP更灵活。    
缺点：带代理的类必须是接口，灵活性受到一些限制；使用反射会影响一些性能。

### 动态代码字节生成
```
public class LogEnhancer {
    private static class MyCallback implements MethodInterceptor{
        @Override
        public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {
            System.out.println("执行AOP织入的代码!!!");
            Object ret = proxy.invokeSuper(obj, args);

            return ret;
        }
    }

    public static void main(String[] args) {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(BarServiceImp.class);
        enhancer.setCallback(new MyCallback());

        BarService service = (BarService) enhancer.create();
        service.doSomething();
    }

}
``` 
如果目标类没有实现接口，Spring AOP 会选择使用 CGLIB 来动态代理目标类。 

CGLIB Code Generation Library ，是一个代码生成的类库，通过动态地对目标对象进行子类化来实现AOP代理，可以在运行时动态的生成某个类的子类。

在运行期，目标类加载后，**动态构建字节码文件生成目标类的子类**，将切面逻辑加入到子类中。

CGLib是动态代码字节生成的实现，它封装字节码生成工具Asm，原理是在运行期间目标字节码加载后，生成目标类的子类，将切面逻辑加入到子类中，所以使用Cglib实现AOP不需要基于接口。

优点：没有接口也可以织入，灵活性高。  
缺点：扩展类的实例方法为final时，则无法进行织入。  
>CGLIB是通过继承的方式做的动态代理，因此如果某个类被标记为`final`，那么它是无法使用CGLIB做动态代理的。

### 自定义类加载器
```
    public static Class enhanceClass() throws Exception {
        ClassPool classPool = ClassPool.getDefault();

        //获取目标类
        CtClass targetClass = classPool.getCtClass("com.spring.core.aop.BarServiceImp");

        //获取织入的连接点
        CtMethod doSomething = targetClass.getDeclaredMethod("doSomething");

        //织入增强代码，这里会重新加载字节码
        doSomething.insertBefore("System.out.println(\"执行AOP织入的代码!!!\");");

        return targetClass.toClass();
    }

    public static void main(String[] args) throws Exception {
        Class clazz = enhanceClass();

        BarService service = (BarService) clazz.newInstance();
        service.doSomething();
    }
```
在运行前，目标加载前，将切面逻辑加到目标字节码中。  
javassist来实现。Javassist 是一个编辑字节码的框架，可以让你很简单地操作字节码。它可以在运行期定义或修改Class。使用Javassist实现AOP的原理是在字节码加载前直接修改需要切入的方法。

优点：可以对绝大部分类织入。  
缺点：如果用到了其他类加载器，则这些类将不被织入

# spring aop
利用@EnableAspectJAutoProxy标签开启切面

- 代理的类未实现任何接口时，spring采用CGLIBl类代理模式
- 代理类实现了接口时，如 BarServiceImpl，Spring默认是采用jdk的接口代理模式; 当设置proxyTargetClass=true时，spring采用cglib类代理。   

[在 Spring Boot 2.0 中，Spring Boot 现在默认使用 CGLIB 动态代理 (基于类的动态代理), 包括 AOP](https://my.oschina.net/spinachgit/blog/3013159)   
如果需要基于接口的动态代理 (JDK 基于接口的动态代理) ，需要设置 spring.aop.proxy-target-class 属性为 false。

也可以使用 AspectJ ,Spring AOP 已经集成了AspectJ 

# Spring内部创建代理对象的过程
在Spring的底层，如果我们配置了代理模式，Spring会为每一个Bean创建一个对应的ProxyFactoryBean的FactoryBean来创建某个对象的代理对象。
通过JDK的针对接口的动态代理模式。  
ProxyFactoryBean提供了如下信息：
```
1). Proxy应该感兴趣的Adivce列表；
2). 真正的实例对象引用ticketService;
3).告诉ProxyFactoryBean使用基于接口实现的JDK动态代理机制实现proxy: 
4). Proxy应该具备的Interface接口：TicketService;
根据这些信息，ProxyFactoryBean就能给我们提供我们想要的Proxy对象了！
```
https://blog.csdn.net/luanlouis/article/details/51155821

>看Spring的代码有个小技巧：如果你要研究一个功能，可以从开启这个功能的Enable注解开始看。Spring的很多功能都是通过Enable注解开启的，所以这些注解肯定和这些功能相关。
可以从@EnableAspectJAutoProxy这个注解开始着手  
[窥探](https://www.cnblogs.com/54chensongxia/p/13141362.html)

# JoinPoint
方法的执行点

# Advice 通知
特定 JoinPoint 处的 Aspect 所采取的动作称为 Advice。Spring AOP 使用一个 Advice 作为拦截器，在 JoinPoint “周围”维护一系列的拦截器。

# Aspect 切面
是通知和切点的结合。通知和切点共同定义了切面的全部内容。是通知和切点的结合。通知和切点共同定义了切面的全部内容。

可以简单地认为, 使用 @Aspect 注解的类就是切面.

# Weaving 织入
把切面应用到目标对象并创建新的代理对象的过程。

## 在Spring中的AOP有6种增强方式（Spring支持哪几种切片）

1、Before 前置增强  
可以进行一些其它的业务操作，比如校验参数是否为空

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

```
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

```