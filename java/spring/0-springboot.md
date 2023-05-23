# Spring Boot 启动流程
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221939990.png)

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


从Spring源码中分析SpringBoot如何省去web.xml

1、META-INF/services/javax.servlet.ServletContainerInitializer


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
 

https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config

http://www.liuhaihua.cn/archives/707636.html 

http://www.liuhaihua.cn/archives/707590.html 

# 为什么通过main函数启动SpringApplication.run()后不会自动退出

