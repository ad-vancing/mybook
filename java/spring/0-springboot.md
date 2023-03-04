一、前言

　　从本博文开始，正式开启Spring及SpringBoot源码分析之旅。这可能是一个漫长的过程，因为本人之前阅读源码都是很片面的，对Spring源码没有一个系统的认识。从本文开始我会持续更新，争取在系列文章更完之后，也能让自己对Spring源码有一个系统的认识。

　　在此立下一个flag，希望自己能够坚持下去。如果有幸让您能从系列文章中学到丁点的知识，还请评论，关注，或推荐。如有错误还请在评论区指出，一起讨论共同成长。

二、SpringBoot诞生的历史背景

　　随着使用 Spring 进行开发的个人和企业越来越多，Spring 也慢慢从一个单一简洁的小框架变成一个大而全的开源软件，Spring 的边界不断的进行扩充，到了后来 Spring 几乎可以做任何事情了，市面上主流的开源软件、中间件都有 Spring 对应组件支持，人们在享用 Spring 的这种便利之后，也遇到了一些问题。Spring 每集成一个开源软件，就需要增加一些基础配置，慢慢的随着人们开发的项目越来越庞大，往往需要集成很多开源软件，因此后期使用 Spirng 开发大型项目需要引入很多配置文件，太多的配置非常难以理解，并容易配置出错，到了后来人们甚至称 Spring 为配置地狱。

　　Spring 似乎也意识到了这些问题，急需有这么一套软件可以解决这些问题，这个时候微服务的概念也慢慢兴起，快速开发微小独立的应用变得更为急迫，Spring 刚好处在这么一个交叉点上，于 2013 年初开始的 Spring Boot 项目的研发，2014年4月，Spring Boot 1.0.0 发布。

　　Spring Boot 诞生之初，就受到开源社区的持续关注，陆续有一些个人和企业尝试着使用了 Spring Boot，并迅速喜欢上了这款开源软件。直到2016年，在国内 Spring Boot 才被正真使用了起来，期间很多研究 Spring Boot 的开发者在网上写了大量关于 Spring Boot 的文章，同时有一些公司在企业内部进行了小规模的使用，并将使用经验分享了出来。从2016年到2018年，使用 Spring Boot 的企业和个人开发者越来越多。2018年SpringBoot2.0的发布，更是将SpringBoot的热度推向了一个前所未有的高度。

三、SpringBoot诞生的技术基础

　1、Spring的发展历史

![0](https://note.youdao.com/yws/res/3273/43C4C7B8033B413D8C492E953FA9B7C8)

（1）spring1.0时代

　　Spring的诞生大大促进了JAVA的发展。也降低了企业java应用开发的技术和时间成本。

（2）spring2.0时代

　　对spring1.0在繁杂的xml配置文件上做了一定的优化,让配置看起来越来越简单,但是并没语完全解决xml冗余的问题。

（3）spring3.0时代

　　可以使用spring提供的java注解来取代曾经xml配置上的问题,似乎我们曾经忘记了发生什么,spring变得前所未有的简单。Spring3.0奠定了SpringBoot自动装配的基础。3.0提供的java注解使得我们可以通过注解的方式来配置spring容器。省去了使用类似于spring-context.xml的配置文件。

同年，Servlet3.0规范的诞生为SpringBoot彻底去掉xml（web.xml）奠定了了理论基础（对于servlet3.0来说，web.xml不再是必需品。但是Servlet3.0规范还是建议保留web.xml）。

（4）spring4.0时代

　　4.0 时代我们甚至连xml配置文件都不需要了完全使用java源码级别的配置与spring提供的注解就能快速的开发spring应用程序,但仍然无法改变Java Web应用程序的运行模式,我们仍然需要将war部署到Web Server 上，才能对外提供服务。

　　4.0开始全面支持java8.0

　　同年，Servlet3.1规范诞生（tomcat8开始采用Servlet3.1规范）。

　2、Servlet3.0奠定了SpringBoot 零xml配置的基础

　　分析SpringBoot如何省去web.xml还得从Servlet3.0的规范说起。Servlet3.0规范规定如下（摘自穆茂强 张开涛翻译的Servlet3.1规范，3.0和3.1在这一点上只有一些细节上的变换，在此不做过多介绍）：

　　ServletContainerInitializer类通过jar services API查找。对于每一个应用，应用启动时，由容器创建一个ServletContainerInitializer 实例。 框架提供的ServletContainerInitializer实现必须绑定在 jar 包 的META-INF/services 目录中的一个叫做 javax.servlet.ServletContainerInitializer 的文件，根据 jar services API，指定 ServletContainerInitializer 的实现。除 ServletContainerInitializer 外，我们还有一个注解@HandlesTypes。在 ServletContainerInitializer 实现上的@HandlesTypes注解用于表示感兴趣的一些类，它们可能指定了 HandlesTypes 的 value 中的注解（类型、方法或自动级别的注解），或者是其类型的超类继承/实现了这些类之一。无论是否设置了 metadata-complete，@HandlesTypes 注解将应用。当检测一个应用的类看是否它们匹配 ServletContainerInitializer 的 HandlesTypes 指定的条件时，如果应用的一个或多个可选的 JAR 包缺失，容器可能遇到类装载问题。由于容器不能决定是否这些类型的类装载失败将阻止应用正常工作，它必须忽略它们，同时也提供一个将记录它们的配置选项。如果ServletContainerInitializer 实现没有@HandlesTypes 注解，或如果没有匹配任何指定的@HandlesType，那么它会为每个应用使用 null 值的集合调用一次。这将允许 initializer 基于应用中可用的资源决定是否需要初始化 Servlet/Filter。在任何 Servlet Listener 的事件被触发之前，当应用正在启动时，ServletContainerInitializer 的 onStartup 方法将被调用。ServletContainerInitializer’s 的onStartup 得到一个类的 Set，其或者继承/实现 initializer 表示感兴趣的类，或者它是使用指定在@HandlesTypes 注解中的任意类注解的。

　　这个规范如何理解呢？

　　简单来说，当实现了Servlet3.0规范的容器（比如tomcat7及以上版本）启动时，通过SPI扩展机制自动扫描所有已添加的jar包下的META-INF/services/javax.servlet.ServletContainerInitializer中指定的全路径的类，并实例化该类，然后回调META-INF/services/javax.servlet.ServletContainerInitializer文件中指定的ServletContainerInitializer的实现类的onStartup方法。 如果该类存在@HandlesTypes注解，并且在@HandlesTypes注解中指定了我们感兴趣的类，所有实现了这个类的onStartup方法将会被调用。

　　再直白一点来说，存在web.xml的时候，Servlet容器会根据web.xml中的配置初始化我们的jar包（也可以说web.xml是我们的jar包和Servlet联系的中介）。而在Servlet3.0容器初始化时会调用jar包META-INF/services/javax.servlet.ServletContainerInitializer中指定的类的实现（javax.servlet.ServletContainerInitializer中的实现替代了web.xml的作用，而所谓的在@HandlesTypes注解中指定的感兴趣的类，可以理解为具体实现了web.xml的功能，当然也可以有其他的用途）。

四、从Spring源码中分析SpringBoot如何省去web.xml

1、META-INF/services/javax.servlet.ServletContainerInitializer

上一节中我们介绍了SpringBoot诞生的技术基础和Servlet3.0规范。这一章节，我们通过Spring源码来分析，Spring是如何实现省去web.xml的。

如下图所示，在org.springframework:spring-web工程下，META-INF/services/javax.servlet.ServletContainerInitializer文件中，指定了将会被Servlet容器启动时回调的类。

![0](https://note.youdao.com/yws/res/3272/BA76E303F8504ECAA956659D5F79DDB7)

2、SpringServletContainerInitializer

查看 SpringServletContainerInitializer 类的源码，发现确实如如上文所说，实现了 ServletContainerInitializer ，并且也在 @HandlesTypes 注解中指定了，感兴趣的类 WebApplicationInitializer

可以看到onStartup方法上有一大段注释，翻译一下大致意思：

servlet 3.0+容器启动时将自动扫描类路径以查找实现Spring的webapplicationinitializer接口的所有实现，将其放进一个Set集合中，提供给 SpringServletContainerInitializer onStartup的第一个参数（翻译结束）。

在Servlet容器初始化的时候会调用 SpringServletContainerInitializer 的onStartup方法，继续看onStartup方法的代码逻辑，在该onStartup方法中利用逐个调用webapplicationinitializer所有实现类中的onStartup方法。

1 @HandlesTypes(WebApplicationInitializer.class) 2 public class SpringServletContainerInitializer implements ServletContainerInitializer { 3 4 /** 5 * Delegate the {@code ServletContext} to any {@link WebApplicationInitializer} 6 * implementations present on the application classpath. 7 *

Because this class declares @{@code HandlesTypes(WebApplicationInitializer.class)}, 8 * Servlet 3.0+ containers will automatically scan the classpath for implementations 9 * of Spring's {@code WebApplicationInitializer} interface and provide the set of all10 * such types to the {@code webAppInitializerClasses} parameter of this method.11 *

If no {@code WebApplicationInitializer} implementations are found on the classpath,12 * this method is effectively a no-op. An INFO-level log message will be issued notifying13 * the user that the {@code ServletContainerInitializer} has indeed been invoked but that14 * no {@code WebApplicationInitializer} implementations were found.15 *

Assuming that one or more {@code WebApplicationInitializer} types are detected,16 * they will be instantiated (and _sorted_ if the @{@link17 * org.springframework.core.annotation.Order @Order} annotation is present or18 * the {@link org.springframework.core.Ordered Ordered} interface has been19 * implemented). Then the {@link WebApplicationInitializer#onStartup(ServletContext)}20 * method will be invoked on each instance, delegating the {@code ServletContext} such21 * that each instance may register and configure servlets such as Spring's22 * {@code DispatcherServlet}, listeners such as Spring's {@code ContextLoaderListener},23 * or any other Servlet API componentry such as filters.24 * @param webAppInitializerClasses all implementations of25 * {@link WebApplicationInitializer} found on the application classpath26 * @param servletContext the servlet context to be initialized27 * @see WebApplicationInitializer#onStartup(ServletContext)28 * @see AnnotationAwareOrderComparator29 */30 @Override31 public void onStartup(@Nullable Set

# SpringBoot和Spring有什么区别
Maven依赖更封装

配置更省略如MVC配置、模板引擎

sp默认嵌入式 Web 服务器（提供了将其部署到外部容器的方式）

# SpringBoot 自动配置的原理
springboot 可以根据 pom 中依赖的 jar 包进行自动配置，并且是在项目启动时已经进行完成的，源码就在 SpringBootApplication 里。

## 加载配置文件 spring.factories
项目启动时执行的初始化方法 `initialize `，调用 `setInitializers`，调用 `getSpringFactoriesInstances`，调用 `loadFactoryNames`。  

FACTORIES RESOURCE LOCATION 这是符号常量，指的是 spring 自动配置的 jar 包下的`resources/META-INF/spring.factories`，也就是首先它加载这个文件。

这个文件里面又很多auto configiuration 自动配置，boot configiuration 包名，autoconfigiurationimportfilter 类名，都是实现自动配置所实现的包和类名。

spring 会使用反射机制进行实例话以及自动装配。

# Springboot自动装配的时候出现bean的错误，怎么解决
Spring基于注解的@Autowired是比较常用的自动装配注解，但是会因为个人的疏忽，SSM进行配置的时候没有将对应bean所在包给扫描进去；或者使用Boot的时候，没有放在启动类所在包及其子包下导致报错。  

1. 查看@ComponentScan会不会扫到api这个包
2. 所需要的类有没有交给Spring给管理，比如加上@Repository注解


# SpringBoot的starter组件的结构是什么样的


# SpringBoot如何自定义starter
https://blog.csdn.net/wangpf2011/article/details/118634417

1）构建独立的maven项目，命名如：sysuser-spring-boot-starter

2）添加spring相关依赖：

3）创建实体SysUser和属性配置文件SysUserProperties（@ConfigurationProperties）

4）编写自动配置类 @EnableAutoConfiguration：

5）创建META-INFO/spring.factories文件，将自动配置类放入其中

6）上述配置完毕后，打包发布jar包，starter组件开发完成。

https://cloud.tencent.com/developer/article/1862609

# SpringBoot启动类 SpringBoot启动原理

https://www.cnblogs.com/xiaoxi/p/7999885.html

@SpringBootApplication = (默认属性)@Configuration + @EnableAutoConfiguration + @ComponentScan。


标注了@Configuration之后，本身其实也是一个IoC容器的配置类;
@ComponentScan的功能其实就是自动扫描并加载符合条件的组件（比如@Component和@Repository等）或者bean定义，最终将这些bean定义加载到IoC容器中。

@EnableAutoConfiguration也是借助@Import的帮助，将所有符合自动配置条件的bean定义加载到IoC容器。
会根据类路径中的jar依赖为项目进行自动配置，如：添加了spring-boot-starter-web依赖，会自动添加Tomcat和Spring MVC的依赖，Spring Boot会对Tomcat和Spring MVC进行自动配置。

@Import(EnableAutoConfigurationImportSelector.class)，借助EnableAutoConfigurationImportSelector，@EnableAutoConfiguration可以帮助SpringBoot应用将所有符合条件的@Configuration配置都加载到当前SpringBoot创建并使用的IoC容器。就像一只“八爪鱼”一样，借助于Spring框架原有的一个工具类：SpringFactoriesLoader的支持，@EnableAutoConfiguration可以智能的自动配置功效才得以大功告成！
spring.factories文件，该文件中定义了关于初始化，监听器等信息

## SpringFactoriesLoader
从classpath中搜寻所有的META-INF/spring.factories配置文件，并将其中org.springframework.boot.autoconfigure.EnableutoConfiguration对应的配置项通过反射（Java Refletion）实例化为对应的标注了@Configuration的JavaConfig形式的IoC容器配置类，然后汇总为一个并加载到IoC容器。

# SpringApplication执行流程

# SpringBoot配置文件加载优先级


    