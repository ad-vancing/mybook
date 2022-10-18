# SpringBoot和Spring有什么区别
Maven依赖更封装

配置更省略如MVC配置、模板引擎

sp默认嵌入式 Web 服务器（提供了将其部署到外部容器的方式）

# Springboot的starter组件的结构是什么样的
Starter组件使开发者不需要关注各种依赖库的处理，不需要具体的配置信息，由SpringBoot自动完成class类发现并加载需要的Bean。

Maven依赖、配置文件（resources/META-INF/spring.factories找到需要自动配置的类）

# Springboot如何自定义starter
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


    