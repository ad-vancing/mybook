# IOC容器管理 bean
- 它们是构成用户应用程序主干的对象。
- Bean 由 Spring IoC 容器管理。
- 它们由 Spring IoC 容器实例化，配置，装配和管理。
- Bean 是基于用户提供给容器的配置元数据创建。
## Bean的命名
在同一个xml配置文件中，id必须是唯一的，但不同的xml可以相同。

## Bean实例化方法
Spring容器也是正常情况下也是通过构造方法创建bean。  
还有静态方法构造和实例工厂方法

## Bean的重写机制
当不同的xml文件中出现同名id属性的bean时后者会覆盖前者。

>Q:Spring 中，有两个 id 相同的 bean，会报错吗，如果会报错，在哪个阶段报错？  
在同一个XML配置文件里面，不能存在id相同的两个bean，否则spring容器启动的时候会报错；  
在两个不同的Spring配置文件里面，可以存在id相同的两个bean。 IOC容器在加载Bean的时候，默认会多个相同id的bean进行覆盖；    
Spring3.x版本以后，@Configuration注解去声明一个配置类，在同一个配置类里面声明多个相同名字的bean，在Spring IOC容器中只会注册第一个声明的Bean的实例。


## Bean的作用域
Bean的作用域是指spring容器创建Bean后的生存周期即由创建到销毁的整个过程。
### Singleton作用域
Spring默认。  
每一个Bean的实例只会被创建一次，而且Spring容器在整个应用程序生存期中都可以使用该实例。因此之前的代码中spring容器创建Bean后，通过代码获取的bean，无论多少次，都是同一个Bean的实例。  
### prototype作用域
`@Scope("prototype")`  
每次获取Bean实例时都会新创建一个实例对象。 
 
当一个Bean被设置为prototype 后Spring就不会对一个bean的整个生命周期负责，容器在初始化、配置、装饰或者是装配完一个prototype实例后，将它交给客户端，随后就对该prototype实例不闻不问了。因此我们需要慎用它，一般情况下，对有状态的bean应该使用prototype作用域，而对无状态的bean则应该使用singleton作用域。所谓有状态就是该bean有保存信息的能力，不能共享，否则会造成线程安全问题，而无状态则不保存信息，是线程安全的，可以共享，spring中大部分bean都是Singleton，整个生命周期过程只会存在一个。

>Q: 当一个作用域为Singleton的Bean依赖于一个作用域为prototype的Bean时，所依赖的实例对象也只会被注入一次，怎么达到目的？

>当一个作用域为Singleton的BeanA依赖于一个作用域为prototype的BeanB时，由于BeanA的依赖BeanB是在BeanA被创建时注入的，而且BeanA是一个Singleton，整个生存周期中只会创建一次，因此它所依赖的BeanB实例对象也只会被注入一次，此后不会再注入任何新的BeanB实例对象。
 为了解决这种困境，只能放弃使用依赖注入BeanB的功能，使用代码实现：通过实现ApplicationContextAware接口，重写setApplicationContext，这样的话Spring容器在创建BeanA实例时会自动注入ApplicationContext对象，此时便可以通过ApplicationContext获取BeanB实例，这样可以保证每次获取的BeanB实例都是新的。
 当一个作用域为propotype的Bean依赖于一个Singleton作用域的Bean时，解决方案跟上述是相同的。   
[参考](https://blog.csdn.net/javazejian/article/details/54561302)



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
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221800049.png)

![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221801962.png)
1. 由构造器或工厂方法根据配置中的 bean 定义创建bean实例  
2. 利用 set()方法为bean的属性设置值或对其他bean的引用   
3. 调用bean的初始化方法  
  1. 如果 bean 实现 BeanNameAware 接口，则工厂通过传递 bean 的 ID 来调用 setBeanName()。
  2. 如果 Bean 实现了 BeanClassLoaderAware 接口，调用 setBeanClassLoader()方法，传入 ClassLoader对象的实例。
  2. 如果 bean 实现 BeanFactoryAware 接口，工厂通过传递自身的实例来调用 setBeanFactory()。
  2. 如果实现了其他 *.Aware接口，就调用相应的方法。
  3. 如果存在与 bean 关联的任何 BeanPostProcessors，则调用 preProcessBeforeInitialization() 方法。
  3. 如果Bean实现了InitializingBean接口，执行afterPropertiesSet()方法。
  4. 如果为 bean 指定了 init 方法（<bean> 的 init-method 属性，@PostConstruct），那么将调用它。
  5. 最后，如果存在与 bean 关联的任何 BeanPostProcessors，则将调用 postProcessAfterInitialization() 方法。
  6. 如果 bean 实现 DisposableBean 接口，当 spring 容器关闭时，会调用 destory()。
  7. 如果为 bean 指定了 destroy相关 方法（<bean> 的 destroy-method 属性，@PreDestroy），那么将调用它。

## 源码方法
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
![图](https://upload-images.jianshu.io/upload_images/4558491-dc3eebbd1d6c65f4.png?imageMogr2/auto-orient/strip|imageView2/2/w/823/format/webp)

- Aware类型的接口（契约接口）  
>Aware类型的接口的作用就是让我们能够拿到Spring容器中的一些资源。基本都能够见名知意，Aware之前的名字就是可以拿到什么资源，例如BeanNameAware可以拿到BeanName，以此类推。调用时机需要注意：所有的Aware方法都是在初始化阶段之前调用的！

>BeanNameAware 可以在Bean中得到它在IOC容器中的Bean的实例的名字。

>BeanFactoryAware 可以在Bean中得到Bean所在的IOC容器，从而直接在Bean中使用IOC容器的服务。

>ApplicationContextAware 可以在Bean中得到Bean所在的应用上下文，从而直接在Bean中使用上下文的服务。  
[参考](https://blog.csdn.net/ilovejava_2010/article/details/7953582)


在设置Bean的属性之后，调用初始化回调方法之前，Spring会调用aware接口中的setter方法。

并不是所有的Aware接口都使用同样的方式调用!Bean××Aware都是在在初始化方法中`invokeAwareMethods(beanName, bean);`  调用的，而ApplicationContext相关的Aware都是通过BeanPostProcessor#postProcessBeforeInitialization()实现的。


- 生命周期接口  
InitializingBean 对应生命周期的初始化阶段，在initializeBean初始化时调用。      
在初始化方法中可以使用Aware接口获取的资源，这也是自定义扩展Spring的常用方式。  

DisposableBean 对应生命周期的销毁阶段，以ConfigurableApplicationContext#close()方法作为入口，实现是通过循环取所有实现了DisposableBean接口的Bean然后调用其destroy()方法 

# 自动装配 autowiring
自动向Bean注入依赖的功能

当 bean 在 Spring 容器中组合在一起时，它被称为装配或 bean 装配。 Spring 容器需要知道需要什么 bean 以及容器应该如何使用依赖注入来将 bean 绑定在一起，同时装配 bean。

解决注入的bean特别多时的配置问题。  
Spring的自动装配有三种模式：byTpye(根据类型)，byName(根据名称)、constructor(根据构造函数)。  
`autowire="byName"`  

简单属性（如原数据类型，字符串和类）无法自动装配。

## 基于注解的自动装配
@Autowired，可以对类成员变量、方法及构造函数进行标注，标注到成员变量时不需要有set方法。  
默认按类型匹配的，需要按名称(byName)匹配的话，可以使用@Qualifier注解与@Autowired结合。  

@Resource，可以标注在成员变量和set方法上，但无法标注构造函数，默认按 byName模式。  

### 可以在Spring中注入一个null 和一个空字符串吗？
可以。

## 使用@Autowired注解自动装配的过程
1. 开启注解：使用@Autowired注解来自动装配指定的bean。在使用@Autowired注解之前需要在Spring配置文件进行配置，<context:annotation-config />。
2. 扫描查询：在启动spring IoC时，容器自动装载了一个AutowiredAnnotationBeanPostProcessor后置处理器，当容器扫描到@Autowied、@Resource或@Inject时，就会在IoC容器自动查找需要的bean，并装配给该对象的属性。在使用@Autowired时，首先在容器中查询对应类型的bean：
- 如果查询结果刚好为一个，就将该bean装配给@Autowired指定的数据；
- 如果查询的结果不止一个，那么@Autowired会根据名称来查找；
- 如果上述查找的结果为空，那么会抛出异常。解决方法时，使用required=false。

# Spring如何维护它拥有的bean
Spring beans 是那些形成Spring应用的主干的java对象。

它们被Spring IOC容器初始化，装配，和管理。

这些beans通过容器中配置的元数据创建。比如，以XML文件中 的形式定义。

**一个Spring Bean 的定义包含容器必知的所有配置元数据，包括如何创建一个bean，它的生命周期详情及它的依赖**。

# 基于Java注解的Bean对象声明
要想把类标识成可用于 @Autowired 注解自动装配的 bean 的类,采用以下注解可实现：  
1. `@Configuration`注解标明BeanConfiguration类，使得BeanConfiguration类替代了xml文件，也就是说注解@Configuration等价于`＜beans＞`标签。在该类中，每个使用注解`@Bean`的公共方法对应着一个`＜bean＞`标签的定义，即`@Bean`等价于`＜bean＞`标签。

2. 其他：@Component、@Service和@Repository、@Controller
   
>这种基于java的注解配置方式声明方式是在spring3.0中引入的，此时使用到注解，因此必须确保`spring-context`包已引入。



# 用于bean初始化方法中执行
- @PostConstruct 注解
可以用在方法上，表示在实例化 bean 之后，在 initializeBean 方法里运行此方法。一个Bean中@PostConstruct注解的方法可以有多个。   
构造方法 ->  @Autowired 依赖注入(属性赋值) -> @PostConstruct方法 -> initializeBean  
 
（ps:@PreDestroy修饰的方法会在服务器卸载Servlet(bean)的时候运行）  
[源码剖析](https://www.cnblogs.com/lixinjie/p/taste-spring-013.html)

- InitializingBean接口
实现InitializingBean接口并重写afterPropertiesSet(),作用同上。

- Bean(initMethod="init")方法注解

- CommanLineRunner 接口，提供了run() 回调方法，spirng上下文初始化完成后应用启动后将会调用。
 
- ApplicationRunner 接口也体用了run()方法，当应用启动时会调用。 

多种机制一起用,执行顺序是：
构造方法 -> @PostConstruct注解的方法 -> InitializingBean的afterPropertiesSet() 方法 -> xml定义的init-method 初始化方法

# BeanFactory 和 FactoryBean 的区别
- BeanFactory  
是一个接口，它是Spring中工厂的顶层规范，是SpringIoc容器的核心接口，它定义了getBean()、containsBean()等管理Bean的通用方法

- FactoryBean  
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
