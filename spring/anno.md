# 注解原理
注解本质是一个继承了Annotation的特殊接口，其具体实现类是Java运行时生成的动态代理类。我们通过反射获取注解时，返回的是Java运行时生成的动态代理对象。通过代理对象调用自定义注解的方法，会最终调用AnnotationInvocationHandler的invoke方法。该方法会从memberValues这个Map中索引出对应的值。而memberValues的来源是Java常量池。

# 自定义注解/元注解
https://blog.csdn.net/xsp_happyboy/article/details/80987484  
java.lang.annotation包  

@Inherited   
使得所标注的注解具有继承性，表示父类的注解可被子类继承

@Retention(RetentionPolicy.RUNTIME)或@Retention (RUNTIME)  
表示注解的存储级别（RetentionPolicy）有三个：源码级（SOURCE ），字节码级（SOURCE ），JVM运行级（RUNTIME）。  
RetentionPolicy.SOURCE 此级别注解只存在于源码中，会被编译器忽略，如@Override, @SuppressWarnings，@Native。  
RetentionPolicy.CLASS 此级别注解会被保存到class文件中，运行时会被JVM忽略。  
RetentionPolicy.RUNTIME 此级别会被保存到class文件，运行时也可以识别，所以可以使用反射机制获取注解信息。比如@Deprecated。

@Target 用来指定Annotation的可标记类型(ElementType)属性。可多种，如@Target({ElementType.TYPE, ElementType.METHOD})
>ElementType 共有八个类型：  
ElementType.ANNOTATION_TYPE 只可以标记注解类型
ElementType.CONSTRUCTOR 标记构造函数
ElementType.FIELD 标记字段或属性
ElementType.LOCAL_VARIABLE 标记本地变量
ElementType.METHOD 标注方法
ElementType.PACKAGE 标注包
ElementType.PARAMETER 标记方法的变量
ElementType.TYPE 标记类中的任何元素

# 声明bean注解
注解装配在默认情况下是不开启的，为了使用注解装配，我们必须在Spring配置文件中配置 `<context:annotation-config/>`元素。
org.springframework.context.annotation
`注解声明@Bean`  
任何一个标注了@Bean的方法，其返回值将作为一个bean定义注册到Spring的IoC容器，方法名将默认成该bean定义的id。

有了注解声明，我们就不需要在xml中通过xml的bean标签配置声明Bean了，但需要明确告诉Spring注解的Bean在那些包下，因此需要添加包扫描机制，此时需要启用Spring的context命名空间：
```xml
<!-- 声明包扫描 -->
    <context:component-scan base-package="com.zejian.spring.springIoc" />
```
它的作用是Spring容器在启动时会启动注解驱动去扫描对应包下的bean对象并将创建它们的实例，极大简化了编程代码。
另外，当spring的xml配置文件出现了＜context:component-scan/＞ 后，＜context:annotation-config/＞就可以退休了，`因为＜context:component-scan/＞已包含了＜context:annotation-config/＞的功能了`。
springboot项目，使用注解`@SpringBootApplication(scanBasePackages = "com.zejian")`

`@Configuration` 
用该注解表明一个类，表示该类替代了xml文件，也就是说注解@Configuration等价于`＜beans＞`标签。内部组合了@Component注解，表明这个类是一个bean，而且是是一个javaConfig配置类。

在`@Configuration`注解的类中，每个使用注解`@Bean`的公共方法对应着一个`＜bean＞`标签的定义，即`@Bean`等价于`＜bean＞`标签。  
这种基于java的注解配置方式是在spring3.0中引入的，此时使用到注解，因此必须确保spring-context包已引入。
指定bean名字：`@Bean(name = "entityManagerPrimary")`
```java
package com.zejian.spring.springIoc.conf;

import com.zejian.spring.springIoc.dao.AccountDao;
import com.zejian.spring.springIoc.dao.impl.AccountDaoImpl;
import com.zejian.spring.springIoc.service.AccountService;
import com.zejian.spring.springIoc.service.impl.AccountServiceImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Created by zejian on 2017/1/15.
 * Blog : http://blog.csdn.net/javazejian [原文地址,请尊重原创]
 */
@Configuration
public class BeanConfiguration {

    @Bean
    public AccountDao accountDao(){
        return new AccountDaoImpl();
    }

    //如果一个bean的定义依赖其他bean,则直接调用对应的JavaConfig类中依赖bean的创建方法就可以了。
    @Bean
    public AccountService accountService(){
        AccountServiceImpl bean=new AccountServiceImpl();
        //注入dao
        bean.setAccountDao(accountDao());
        return bean;
    }
}

```


`@Service @Repository @Controller @Component `
org.springframework.stereotype
这几个含义并无差异，只不过
@Service 用于对Service实现类进行标注，更能让我们明白该类为业务类罢了。
@Repository 用于对DAO实现类进行标注。
@Controller 用于对Controller实现类进行标注（web层控制器）。
@Component表名它们是组件类，没有明确的角色。
里面传入一个String值的名称，如果没有提供名称，那么默认情况下就是一个简单的类名(第一个字符小写)变成Bean名称。

`@Scope`
org.springframework.context.annotation
通过注解来声明作用域
@Scope("prototype")
@Scope(value = "singleton")
声明代理模式
@Scope(value = "prototype" , proxyMode = ScopedProxyMode.TARGET_CLASS)


# 自动装备bean的注解
`@Autowired`
org.springframework.beans.factory.annotation
Spring 2.5 中引入了注释，默认`按类型进行查找`。如PersonDao p，他会去xml文件里查找类型为PersonDao的元素。
它可以对类成员变量（不需要有set方法）、方法及构造函数进行标注，完成自动装配的工作。 
一般使用成员变量注入，这样可以省略set方法和构造方法，简洁。  
`@Qualifier("secondaryJdbcTemplate")`
如果一个接口有多个实现，需要和@Qualifier配合使用，指定Bean的名称或id，表示`按名称(byName)进行查找`。
另外，它还有分组的功能，用的比较少，在springcloud里通过它扩展了@LoadBalanced注解，区分了有负载均衡和无负载均衡能力的RestTemplate
`required属性`
required=false，false指明当实例存在就注入不存就忽略，如果为true，就必须注入，若实例不存在，就抛出BeanInitializationException异常。


`@Resource`
javax.annotation，由JSR-250提供。
默认`按 byName进行查找`，只有当找不到与名称匹配的bean才会按照类型来装配注入。
有两个中重要的属性：name和type ，Spring将@Resource注解的name属性解析为bean的名字，而type属性则解析为bean的类型。所以如果使用name属性，则使用byName的自动注入策略，而使用type属性时则使用 byType自动注入策略。如果既不指定name也不指定type属性，这时将通过反射机制使用byName自动注入策略。
@Resource可以作用于字段上，但无法标注构造函数。当作用于字段上的时候，如果我们只是简单的这样写：
```
@Resource
private PersonDao  p;
```
这时候spring注入p的过程是 1：先查找xml中是否有id为p的元素，如果没有找到，则看是否有name属性（@Resource  name=“”），有则查找name，否则否则查找Persondao类型的元素。

@Resource可以作用于set函数上
```
@Resource
public void setP(PersonDao p) {
 this.p = p;
  }
```
总结@Resource装配顺序：
(1). 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常;
(2). 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常;
(3). 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常;
(4). 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配；



`@Value`
org.springframework.beans.factory.annotation
上述两种自动装配的依赖注入并不适合简单值类型，如int、boolean、long、String以及Enum等。
一般情况下@Value会与properties文件结合使用，也分两种情况一种是SpEL（有点类似于jsp的EL），另外一种是占位符方式。
xml配置：
```xml
    <!--基于占位符方式 配置单个properties -->
    <!--<context:property-placeholder location="conf/jdbc.properties"/>-->
    <!--基于占位符方式 配置多个properties -->
    <bean id="propertyConfigurer" class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
        <property name="location" value="conf/jdbc.properties"/>
    </bean>

    <!--基于SpEL表达式 配置单个properties -->
    <!--<util:properties id="configProperties" location="classpath:conf/jdbc.properties"/>-->

    <!--基于SpEL表达式 配置多个properties id值为configProperties 提供java代码中使用 -->
    <bean id="configProperties" class="org.springframework.beans.factory.config.PropertiesFactoryBean">
        <property name="locations">
            <list>
                <value>classpath:/conf/jdbc.properties</value>
            </list>
        </property>
    </bean>

```

```java
    //占位符方式
    @Value("${jdbc.url}")
    private String url;
    //SpEL表达方式，其中代表xml配置文件中的id值configProperties
    @Value("#{configProperties['jdbc.username']}")
    private String userName;
```

1).注入普通字符

@Value("Michael")

String name;
2).注入操作系统属性

@Value("#{systemProperties['os.name']}")

String osName;
3).注入表达式结果

@Value("#{ T(java.lang.Math).random() * 100}")

String randomNumber;
4).注入其它bean属性

@Value("#{ domeClass.name}")

String name;
5).注入文件资源

@Value("classpath:com/it/test.txt")

String Resource file;
6).注入网站资源

@Value("http://www.baidu.com")

Resource url;
7).注入配置文件

@Value("${book.name} ")

String bookName;
注入配置使用方法：

① 编写配置文件（test.properties）

book.name=《三体》

② @PropertySource 加载配置文件(类上)

@PropertySource("classpath:com/it/test.properties")
③ 还需配置一个PropertySourcesPlaceholderConfigurer的bean。

# Bean的属性注解
@Scope 设置Spring容器如何新建Bean实例（方法上，得有@Bean）

其设置类型包括：

Singleton （单例,一个Spring容器中只有一个bean实例，默认模式）,

Protetype （每次调用新建一个bean）,

Request （web项目中，给每个http request新建一个bean）,

Session （web项目中，给每个http session新建一个bean）,

GlobalSession（给每一个 global http session新建一个Bean实例）

@StepScope 在Spring Batch中还有涉及

@PostConstruct 由JSR-250提供，在构造函数执行完之后执行，等价于xml配置文件中bean的initMethod

@PreDestory 由JSR-250提供，在Bean销毁之前执行，等价于xml配置文件中bean的destroyMethod

# web相关
[post请求参数注解](https://www.cnblogs.com/cashew/p/8978589.html)
在Spring MVC 中，控制器Controller 负责处理由DispatcherServlet 分发的请求，它把用户请求的数据经过业务处理层处理之后封装成一个Model ，然后再把该Model 返回给对应的View 进行展示。在Spring MVC 中提供了一个非常简便的定义Controller 的方法，你无需继承特定的类或实现特定的接口，只需使用@Controller 标记一个类是Controller ，然后使用@RequestMapping 和@RequestParam 等一些注解用以定义URL 请求和Controller 方法之间的映射，这样的Controller 就能被外界访问到。此外Controller 不会直接依赖于HttpServletRequest 和HttpServletResponse 等HttpServlet 对象，它们可以通过Controller 的方法参数灵活的获取到。

@Controller 用于标记在一个类上，使用它标记的类就是一个Spring MVC Controller 控制器类。
五大作用域： 原型  单例  request  session  全局session

@RequestMapping 用于映射Web请求，包括访问路径和参数（类或方法上）。使用@RequestMapping 注解的方法才是真正处理请求的处理器。
RequestMapping注解有六个属性：
- value：指定请求的实际地址，指定的地址可以是URI Template 模式
- method： 指定请求的method类型， GET、POST、PUT、DELETE等
- consumes： 指定处理请求的提交内容类型（Content-Type），例如application/json, text/html;
- produces: 指定返回的内容类型，仅当request请求头中的(Accept)类型中包含该指定类型才返回；
- params： 指定request中必须包含某些参数值是，才让该方法处理。
比如在拦截请求中,我想拦截提交参数中包含"type=test"字符串,可以在@RequestMapping注解里面加上`params="type=test"`
- headers： 指定request中必须包含某些指定的header值，才能让该方法处理请求。

@PathVariable 从请求URI中提取一个特定模版变量的值来作为我们的请求参数。比如@RequestMapping(“/hello/{name}”)申明的路径，将注解放在参数中前，即可获取该值，通常作为
Restful的接口实现方法。需要特别指出的是通过此注解获取的值不会被编码。

@RequestParam 用来获得静态的URL请求入参

@RequestBody 用来接收前端传递的json字符串(放在请求体中)，**通过springmvc提供的HttpMessageConverter将json数据反序列化到Java对象中，默认使用jackson类库反序列化，然后绑定到Controller方法的参数上**。[参考](https://www.cnblogs.com/classmethond/p/10800493.html)    
GET方式无请求体，所以使用@RequestBody接收数据时，前端不能使用GET方式提交数据，而是用POST方式进行提交。在后端的同一个接收方法里，@RequestBody与@RequestParam()可以同时使用，@RequestBody最多只能有一个，而@RequestParam()可以有多个。
注：一个请求，只有一个RequestBody；一个请求，可以有多个RequestParam。
https://blog.csdn.net/justry_deng/article/details/80972817

@ResponseBody 将Controller的方法返回的对象，**通过适当的HttpMessageConverter转换为指定格式**后，如：json,xml等，写入到Response对象的body数据区。使用时机：返回的数据不是html标签的页面，而是其他某种格式的数据时（如json、xml等）使用。

@RestController 该注解为一个组合注解，相当于@Controller和@ResponseBody的组合，注解在类上，意味着，该Controller的所有方法都默认加上了@ResponseBody。
加上@ResponseBody意思是返回json或xml到前台页面，也就是return里的东西。这时候，即使你在视图解析器InternalResourceViewResolver中配置相应的返回页面也是不起作用的。
**如果用@Controller注解，则可以配置视图解析器，return里的是要返回的jsp路径。**
**它俩的区别就是return后的是返回的内容还是返回的路径。**
补：用ajax访问获取数据时，相应的后台方法要加@ResponseBody，就是因为ajax接收Json数据作为返回值。

@ControllerAdvice 通过该注解，我们可以将对于控制器的全局配置放置在同一个位置，注解了@Controller的类的方法可使用@ExceptionHandler
、@InitBinder、@ModelAttribute注解到方法上，这对所有注解了 @RequestMapping的控制器内的方法有效。也可使用@RestControllerAdvice。

@ExceptionHandler 用于全局处理控制器里的异常
系统的dao、service、controller出现都通过throws Exception向上抛出，最后由springmvc前端控制器交由异常处理器进行异常处理。
系统中异常包括两类：预期异常【可以预料的】和运行时异常【运行前不知道的】RuntimeException，前者通过捕获异常从而获取异常信息，后者主要通过规范代码开发。
springmvc在处理请求过程中出现异常信息交由异常处理器进行处理，自定义异常处理器可以实现一个系统的异常处理逻辑。
```
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 手机号，车牌号，ip格式校验， 控制层，在自定义类参数前加 @Validated 即可生效
     * 传json字符串，校验出错
     * @param e
     * @return
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseBody
    public RestResponse<Object> exceptionMethod1(MethodArgumentNotValidException e) {
        RestResponse<Object> rr = new RestResponse<Object>();
        BindingResult bindingResult = e.getBindingResult();
        FieldError fieldError = bindingResult.getFieldError();
        rr.setStatus("500");
        rr.setMessage(fieldError.getField() + " " + fieldError.getDefaultMessage());
        return rr;
    }
```



@InitBinder 用来设置WebDataBinder，WebDataBinder用来自动绑定前台请求参数到Model中。

@ModelAttribute 本来的作用是绑定键值对到Model里，在@ControllerAdvice中是让全局的@RequestMapping都能获得在此处设置的键值对。request作用域。https://www.cnblogs.com/jpfss/p/11353771.html
它将方法参数或方法返回值绑定到Model属性中，然后将其公开给Web视图。如果我们在方法级别使用它，则表明该方法的目的是添加一个或多个模型属性。另一方面，当用作方法参数时，它表示应从模型中检索参数。如果不存在，我们应该首先实例化它，然后将其添加到Model中。一旦出现在模型中，我们应该填充所有具有匹配名称的请求参数的参数字段。

@SessionAttributes 在类上面加上@SessionAttributes注解即可把数据放入Session里面


# 配置类相关
@ComponentScan 用于对Component进行扫描

@WishlyConfiguration 为@Configuration与@ComponentScan的组合注解，可以替代这两个注解

@SpringBootApplication(scanBasePackages = "com.infoholdcity.parking")
@EnableMBeanExport(registration = RegistrationPolicy.IGNORE_EXISTING)
@EnableFeignClients(basePackages = "com.infoholdcity.parking.common.feign")
@MapperScan(value = {"com.infoholdcity.parking.repository.*.dao"})
@EnableScheduling
@EnableTransactionManagement

@Enable*注解说明
这些注解主要用来开启对xxx的支持。

@EnableAspectJAutoProxy 开启对AspectJ自动代理的支持

@EnableAsync 开启异步方法的支持

@EnableScheduling 开启计划任务的支持

@EnableWebMvc 开启Web MVC的配置支持

@EnableConfigurationProperties 开启对@ConfigurationProperties注解配置Bean的支持
https://juejin.im/post/5cb2f9f26fb9a068b748ab33

@EnableJpaRepositories 开启对SpringData JPA Repository的支持

@EnableTransactionManagement 开启注解式事务的支持

@EnableTransactionManagement 开启注解式事务的支持

@EnableCaching 开启注解式的缓存支持



环境切换
@Profile 通过设定Environment的ActiveProfiles来设定当前context需要使用的配置环境。（类或方法上）

@Conditional Spring4中可以使用此注解定义条件话的bean，通过实现Condition接口，并重写matches方法，从而决定该bean是否被实例化。

# 切面相关
@Aspect 声明一个切面

使用@After、@Before、@Around定义建言（advice），可直接将拦截规则（切点）作为参数。

@After 在方法执行之后执行（方法上）

@Before 在方法执行之前执行（方法上）

@Around 在方法执行之前与之后执行（方法上）

@PointCut 声明切点

在java配置类中使用@EnableAspectJAutoProxy注解开启Spring对AspectJ代理的支持（类上）


# 异步相关
@EnableAsync 配置类中，通过此注解开启对异步任务的支持，叙事性AsyncConfigurer接口（类上）

@Async 在实际执行的bean方法使用该注解来申明其是一个异步任务（方法上或类上所有的方法都将异步，需要@EnableAsync开启异步任务）

# 定时任务相关
@EnableScheduling 在配置类上使用，开启计划任务的支持（类上）

@Scheduled 来申明这是一个任务，包括cron,fixDelay,fixRate等类型（方法上，需先开启计划任务的支持

# 测试相关注解
@RunWith 运行器，Spring中通常用于对JUnit的支持

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration 用来加载配置ApplicationContext，其中classes属性用来加载配置类

@ContextConfiguration(classes={TestConfig.class})

Spring部分：
@EnableWebMvc 在配置类中开启Web MVC的配置支持，如一些ViewResolver或者MessageConverter等，若无此句，重写WebMvcConfigurerAdapter

方法（用于对SpringMVC的配置）。



jrx注解
https://blog.csdn.net/lazycheerup/article/details/83899769




@PostConstruct
https://www.cnblogs.com/YuyuanNo1/p/8184003.html
使用场景：https://zhuanlan.zhihu.com/p/126749381

# springboot测试使用的注解 @TestConfiguration、@TestComponent等
1、在语义上用来指定某个Bean是专门用于测试的。
2、@TestConfiguration能够直接覆盖已存在的Bean，这一点正常的@Configuration是做不到的。
如果你使用@SpringBootApplication启动测试或者生产代码，@TestComponent会自动被排除掉，如果不是则需要像@SpringBootApplication一样添加TypeExcludeFilter


@EnableConfigurationProperties：这是一个开启使用配置参数的注解，value值就是我们配置实体参数映射的ClassType，将配置实体作为配置来源。

以下为SpringBoot内置条件注解：
@ConditionalOnBean：当SpringIoc容器内存在指定Bean的条件
@ConditionalOnClass：当SpringIoc容器内存在指定Class的条件
@ConditionalOnExpression：基于SpEL表达式作为判断条件
@ConditionalOnJava：基于JVM版本作为判断条件
@ConditionalOnJndi：在JNDI存在时查找指定的位置
@ConditionalOnMissingBean：当SpringIoc容器内不存在指定Bean的条件
@ConditionalOnMissingClass：当SpringIoc容器内不存在指定Class的条件
@ConditionalOnNotWebApplication：当前项目不是Web项目的条件
@ConditionalOnProperty：指定的属性是否有指定的值
@ConditionalOnResource：类路径是否有指定的值
@ConditionalOnSingleCandidate：当指定Bean在SpringIoc容器内只有一个，或者虽然有多个但是指定首选的Bean
@ConditionalOnWebApplication：当前项目是Web项目的条件
以上注解都是元注解@Conditional演变而来的，根据不用的条件对应创建以上的具体条件注解。

# [ @condition 注解](https://www.cnblogs.com/huzi007/p/6222289.html)
用来在不同条件下注入不同实现的

[more demo](http://www.itsoku.com/article/278#menu_9)

[good demo](https://yunfan.blog.csdn.net/article/details/100857814?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-9.pc_relevant_baidujshouduan&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-9.pc_relevant_baidujshouduan)

[源码级](https://blog.csdn.net/hou_ge/article/details/108401072?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.pc_relevant_baidujshouduan&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.pc_relevant_baidujshouduan)

[欢迎更多](https://blog.csdn.net/yusimiao/article/details/98027367)
@ConditionalOnProperty(value = "opentracing.jaeger.enabled", havingValue = "false", matchIfMissing = false)
https://www.thinbug.com/q/51257432

[看看](https://github.com/LuckyShawn/spring-annotation/tree/master/src/main/java/com/shawn)
