# IOC容器管理 bean
## Bean的命名
在同一个xml配置文件中，id必须是唯一的，但不同的xml可以相同。

## Bean实例化方法
Spring容器也是正常情况下也是通过构造方法创建bean。  
还有静态方法构造和实例工厂方法

## Bean的重写机制
当不同的xml文件中出现同名id属性的bean时后者会覆盖前者。

>Q:Spring 中，有两个 id 相同的 bean，会报错吗，如果会报错，在哪个阶段报错？  
https://blog.csdn.net/q331464542/article/details/125220859

## Bean的作用域
Bean的作用域是指spring容器创建Bean后的生存周期即由创建到销毁的整个过程。
### Singleton作用域
Spring默认。  
每一个Bean的实例只会被创建一次，而且Spring容器在整个应用程序生存期中都可以使用该实例。因此之前的代码中spring容器创建Bean后，通过代码获取的bean，无论多少次，都是同一个Bean的实例。  
### prototype作用域
`@Scope("prototype")`  
每次获取Bean实例时都会新创建一个实例对象。  
#### 当一个作用域为Singleton的Bean依赖于一个作用域为prototype的Bean时
所依赖的实例对象也只会被注入一次。
怎么达到目的，见 https://blog.csdn.net/javazejian/article/details/54561302

>当一个Bean被设置为prototype 后Spring就不会对一个bean的整个生命周期负责，容器在初始化、配置、装饰或者是装配完一个prototype实例后，将它交给客户端，随后就对该prototype实例不闻不问了。因此我们需要慎用它，一般情况下，对有状态的bean应该使用prototype作用域，而对无状态的bean则应该使用singleton作用域。所谓有状态就是该bean有保存信息的能力，不能共享，否则会造成线程安全问题，而无状态则不保存信息，是线程安全的，可以共享，spring中大部分bean都是Singleton，整个生命周期过程只会存在一个。


### request
对于每次HTTP请求到达应用程序，Spring容器会创建一个全新的Request作用域的bean实例，且该bean实例仅在当前HTTP request内有效，整个请求过程也只会使用相同的bean实例，当处理请求结束，request作用域的bean实例将被销毁。

### session
每当创建一个新的HTTP Session时就会创建一个Session作用域的Bean，并该实例bean伴随着会话的存在而存在。

### globalSession作用域
相当于全局变量，类似Servlet的Application，适用基于portlet的web应用程序，请注意，portlet在这指的是分布式开发。

## Bean的延迟加载
默认情况下Spring容器在启动阶段就会创建bean，这个过程被称为预先bean初始化，这样是有好处的，可尽可能早发现配置错误，如配置文件的出现错别字或者某些bean还没有被定义却被注入等。   
当然如存在大量bean需要初始化，这可能引起spring容器启动缓慢，一些特定的bean可能只是某些场合需要而没必要在spring容器启动阶段就创建，这样的bean可能是Mybatis的SessionFactory或者Hibernate SessionFactory等，延迟加载它们会让Spring容器启动更轻松些，从而也减少没必要的内存消耗。

延迟初始化的bean可能被注入到一个非延迟创建且作用域为singleton的bean时会延迟配置失效。

# Spring bean的生命周期

![](https://img-blog.csdnimg.cn/201911012343410.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RoaW5rV29u,size_16,color_FFFFFF,t_70)

由构造器或工厂方法创建bean实例
为bean的属性设置值或对其他bean的引用
调用bean的初始化方法
bean可以使用了
当容器关闭时，调用bean的销毁方法

主要逻辑都在doCreateBean()方法中：  
createBeanInstance() -> 实例化  
populateBean() -> 属性赋值  
initializeBean() -> 初始化  


实例化 Instantiation
属性赋值 Populate
初始化 Initialization
销毁 Destruction（在容器关闭时调用）  

# bean生命周常用扩展点
https://www.jianshu.com/p/1dec08d290c1
有两个重要的bean生命周期方法，第一个是setup ， 它是在容器加载bean的时候被调用。
第二个方法是 teardown 它是在容器卸载类的时候被调用。

- InstantiationAwareBeanPostProcessor(继承了BeanPostProcessor接口)作用于实例化阶段的前后。  
postProcessBeforeInstantiation在doCreateBean之前调用，也就是在bean实例化之前调用的，英文源码注释解释道该方法的返回值会替换原本的Bean作为代理，这也是Aop等功能实现的关键点。  

- BeanPostProcessor 作用于初始化阶段的前后。  
![](https://upload-images.jianshu.io/upload_images/4558491-dc3eebbd1d6c65f4.png?imageMogr2/auto-orient/strip|imageView2/2/w/823/format/webp)

- Aware类型的接口（契约接口）
Aware类型的接口的作用就是让我们能够拿到Spring容器中的一些资源。基本都能够见名知意，Aware之前的名字就是可以拿到什么资源，例如BeanNameAware可以拿到BeanName，以此类推。调用时机需要注意：所有的Aware方法都是在初始化阶段之前调用的！

BeanNameAware  
BeanClassLoaderAware  
BeanFactoryAware  

EnvironmentAware  
ApplicationContextAware

在初始化阶段之前调用。
并不是所有的Aware接口都使用同样的方式调用!Bean××Aware都是在在初始化方法中`invokeAwareMethods(beanName, bean);`  调用的，而ApplicationContext相关的Aware都是通过BeanPostProcessor#postProcessBeforeInitialization()实现的。


- 生命周期接口  
InitializingBean 对应生命周期的初始化阶段，在initializeBean初始化时调用。    
在初始化方法中可以使用Aware接口获取的资源，这也是自定义扩展Spring的常用方式。

DisposableBean 对应生命周期的销毁阶段，以ConfigurableApplicationContext#close()方法作为入口，实现是通过循环取所有实现了DisposableBean接口的Bean然后调用其destroy()方法 

## bean 实例化过程
Spring将值和bean的引用注入到bean对应的属性中；  
如果bean实现了BeanNameAware接口，Spring将bean的ID传递给setBean-Name()方法；  
如果bean实现了BeanFactoryAware接口，Spring将调用setBeanFactory()方法，将BeanFactory容器实例传入；  
如果bean实现了ApplicationContextAware接口，Spring将调用setApplicationContext()方法，将bean所在的应用上下文的引用传入进来；  
如果bean实现了BeanPostProcessor接口，Spring将调用它们的post-ProcessBeforeInitialization()方法；  
如果bean实现了InitializingBean接口，Spring将调用它们的after-PropertiesSet()方法。类似地，如果bean使用initmethod声明了初始化方法，该方法也会被调用；  
如果bean实现了BeanPostProcessor接口，Spring将调用它们的post-ProcessAfterInitialization()方法；  
此时，bean已经准备就绪，可以被应用程序使用了，它们将一直驻留在应用上下文中，直到该应用上下文被销毁；  
如果bean实现了DisposableBean接口，Spring将调用它的destroy()接口方法。同样，如果bean使用destroy-method声明了销毁方法，该方法也会被调用。

# 用于bean初始化方法中执行
- @PostConstruct 注解
可以用在方法上，表示在实例化 bean 之后，在 initializeBean 方法里运行此方法。一个Bean中@PostConstruct注解的方法可以有多个。   
构造方法 ->  @Autowired 依赖注入(属性赋值) -> @PostConstruct方法 -> initializeBean  
 
（ps:@PreDestroy修饰的方法会在服务器卸载Servlet(bean)的时候运行）  
https://www.cnblogs.com/lixinjie/p/taste-spring-013.html

- InitializingBean接口
实现InitializingBean接口并重写afterPropertiesSet(),作用同上。

- Bean(initMethod="init")方法注解

- CommanLineRunner 接口，提供了run() 回调方法，spirng上下文初始化完成后应用启动后将会调用。
 
- ApplicationRunner 接口也体用了run()方法，当应用启动时会调用。 

多种机制一起用,执行顺序是：
构造方法 -> @PostConstruct注解的方法 -> InitializingBean的afterPropertiesSet() 方法 -> xml定义的init-method 初始化方法

# BeanFactory 和 FactoryBean 的区别
BeanFactory是一个接口，它是Spring中工厂的顶层规范，是SpringIoc容器的核心接口，它定义了getBean()、containsBean()等管理Bean的通用方法

FactoryBean
首先它是一个Bean，但又不仅仅是一个Bean。它是一个能生产或修饰对象生成的工厂Bean，类似于设计模式中的工厂模式和装饰器模式。
它能在需要的时候生产一个对象，且不仅仅限于它自身，它能返回任何Bean的实例。
FactoryBean表现的是一个工厂的职责。 即一个Bean A如果实现了FactoryBean接口，那么A就变成了一个工厂。

https://www.yisu.com/zixun/597801.html

https://zhuanlan.zhihu.com/p/266901018



## Spring框架中的单例bean是线程安全的吗
不是。  
实际上大部分时候 spring bean 无状态的（比如 dao 类），所有某种程度上来说 bean 也是安全的，但如果 bean 有状态的话（比如 view model 对象），那就要开发者自己去保证线程安全了。  

> 有状态就是有数据存储功能。
无状态就是不会保存数据。
