
# 什么是Spring MVC 
是 spring 的一个模块。  
是一个基于Java的实现了MVC设计模式的请求驱动类型的轻量级Web框架。
通过把Model，View，Controller分离，将web层进行职责解耦，把复杂的web应用分成逻辑清晰的几部分，简化开发，减少出错，方便组内开发人员之间的配合。

![](https://pic1.zhimg.com/v2-642df23c5fc99101fb6d9fb693446b90_r.jpg)

# Spring MVC的优点
- 可以支持各种视图技术,而不仅仅局限于JSP；
- 与Spring框架集成（如IoC容器、AOP等）；
- 清晰的角色分配：前端控制器(dispatcherServlet) , 请求到处理器映射（handlerMapping), 处理器适配器（HandlerAdapter), 视图解析器（ViewResolver）。
- 支持各种请求资源的映射策略。

# Spring MVC和struts2
它们都是基于mvc的表现层框架，都用于web项目的开发，但有以下不同点：
- 前端控制器不一样
springmvc的入口是一个servlet即前端控制器（DispatchServlet），而struts2入口是一个filter过虑器（StrutsPrepareAndExecuteFilter）。
- 请求参数的接收方式不一样
springmvc是基于方法开发(一个url对应一个方法)，请求参数传递到方法的形参，线程安全，可以设计为单例或多例(建议、默认单例)，struts2是基于类开发，传递参数是通过类的属性，线程不安全，只能设计为多例。
多例是以类为单位，每一个请求创建一个类
单例是以方法为单位，每一个请求创建【复制】一个方法
- Struts采用值栈存储请求和响应的数据，springmvc采用request域存储请求和响应的数据
Struts通过OGNL存取数据，springmvc通过参数解析器是将request请求内容解析，并给方法形参赋值，将数据和视图封装成ModelAndView对象，最后又将ModelAndView中的模型数据通过reques域传输到页面。Jsp视图解析器默认使用jstl。

# Spring MVC的主要组件
处理器映射器、处理器适配器、视图解析器称为springmvc的三大组件。需要用户开发的组件有controller、view。

- 前端控制器 DispatcherServlet（不需要程序员开发）
作用：接收请求、响应结果，相当于转发器，有了DispatcherServlet 就减少了其它组件之间的耦合度。
Spring的MVC框架是围绕DispatcherServlet来设计的，它用来处理所有的HTTP请求和响应。
- 处理器映射器HandlerMapping（不需要程序员开发，准确说是  DefaultAnnotationHandlerMapping）
作用：根据请求的URL来查找Handler
Spring MVC提供了不同的映射器实现不同的映射方式，例如：配置文件方式，实现接口方式，注解方式等
- 处理器适配器HandlerAdapter
注意：在编写Handler的时候要按照HandlerAdapter要求的规则去编写，这样适配器HandlerAdapter才可以正确的去执行Handler。
这是适配器模式的应用，通过扩展适配器可以对更多烈性的处理器进行执行。
- 处理器Handler（需要程序员开发）
Handler是继DispatcherServlet前端控制器的后端控制器，在DispatcherServlet的控制下Handler对据图的用户请求进行处理，由于Handller涉及到具体的用户业务请求，所以一般情况需要工程师根据业务需求开发Handler
- 视图解析器 ViewResolver（不需要程序员开发）
作用：进行视图的解析，根据视图逻辑名解析成真正的视图（view）
- 视图View（需要程序员开发jsp）
View是一个接口， 它的实现类支持不同的视图类型（jsp，freemarker，pdf等等）

>WebApplicationContext 继承了ApplicationContext 并增加了一些WEB应用必备的特有功能，它不同于一般的ApplicationContext ，因为它能处理主题，并找到被关联的servlet。

## Spring的MVC框架是围绕DispatcherServlet来设计的，它用来处理所有的HTTP请求和响应。

```
    protected void initStrategies(ApplicationContext context) {
    //文件上传解析器，如果请求类型是multipart，将通过MultipartResolver进行文件上传解析；
    //CommonsMultipartResolver extends CommonsFileUploadSupport implements MultipartResolver, ServletContextAware
        this.initMultipartResolver(context);
        
        //LocaleResolver，国际化时候使用，通过配置不同的LocaleResolver来达到实现展示不同的视图的目的，需要指定的ViewResolver辅以支持。https://www.cnblogs.com/twodog/p/12135846.html
        this.initLocaleResolver(context);
        
        //主题解析，通过它来实现一个页面多套风格，即常见的类似于软件皮肤效果
        this.initThemeResolver(context);
        
        //请求映射处理器，RequestMappingHandlerMapping
        this.initHandlerMappings(context);
        
        //适配器，依据某某规则分发到目标Controller，这个过程需要HandlerMapping和HandlerAdapter.【适配器设计模式的应用】
        this.initHandlerAdapters(context);
        
        //处理器异常解析，可以将异常映射到相应的统一错误界面，从而显示用户友好的界面
        this.initHandlerExceptionResolvers(context);
        
        
        this.initRequestToViewNameTranslator(context);
        
        //视图解析器，把逻辑视图名解析为具体的View
        this.initViewResolvers(context);
    }
```

# Spring MVC的流程
![图](https://img-blog.csdn.net/20180708224853769?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2E3NDUyMzM3MDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
1. 用户发送请求至前端控制器DispatcherServlet；
2. DispatcherServlet收到请求后，调用HandlerMapping处理器映射器，请求获取Handle；
3. 处理器映射器根据请求url找到具体的处理器Controller，生成处理器对象及处理器拦截器(如果有则生成)一并返回给DispatcherServlet；
4. DispatcherServlet 调用 HandlerAdapter处理器适配器；
5. HandlerAdapter 经过适配调用 具体处理器Controller；
6. Controller执行完成返回ModelAndView（视图路径和数据）；
7. HandlerAdapter将Handler执行结果ModelAndView返回给DispatcherServlet；
8. DispatcherServlet将ModelAndView传给ViewResolver视图解析器进行解析；
9. ViewResolver解析后返回具体View；
10. DispatcherServlet对View进行渲染视图（即将模型数据填充至视图中）
11. DispatcherServlet响应用户。

# Spring mvc初始化过程
https://blog.csdn.net/wqadxmm/article/details/115182792

https://chenliny.com/archives/457/

1 web容器启动。

2 Spring根IOC容器初始化：

     2.1）contextLoaderListener监听到容器初始化事件，调用contextInitialized()方法。

     2.2）创建根IOC容器。

     2.3）设置全局上下文到根容器中。

     2.4）加载Spring各项配置。

     2.5）调用refresh方法完成Spring各项配置初始化。

     2.6）将根IOC容器设置到全局上下文环境ServletContext的Attribute中。

3 初始化web.xml中Filter。

4 SpringMVC子IOC容器初始化（web.xml中DispatcherServlet）：

     4.1）调用servlet.init方法。

     4.2）初始化参数。

     4.3）创建子IOC容器。

     4.4）加载SpringMVC各项配置。

     4.5）从全局上下文环境ServletContext的Attribute中，取得根IOC容器并设置为父容器，建立父子容器关系。

     4.6）调用refresh方法完成SpringMVC各项组件初始化。

     4.7）将子IOC容器设置到全局上下文环境ServletContext的Attribute中。

   
# Spring mvc的DispatcherServlet源码，工作机制。   
它是一个派发器，即对任意一个web请求都会根据一定的规则派发到对应的处理器上处理，并最终将结果返回。  

## DispatcherServlet的初始化
DispatcherServlet继承自FrameworkServlet（FrameworkServlet 又继承自 HttpServletBean），初始化web application context并加载配置，这个操作完毕后，会调用onRefresh(ApplicationContext context)方法。
该方法从用户定义的application context中加载自定义的bean或者从默认文件中加载各种bean，用于初始化HandlerMapping, HandlerAdapter, HandlerExceptionResolver等bean对象。

## DispatcherServlet对web请求的处理
通过调用其service(ServletRequest req, ServletResponse res)方法来实现的，这个方法实现了对一个请求的具体响应处理逻辑。 

DispatcherServlet处理一个请求的整个调用链可用下图来描述：
![](https://img-blog.csdnimg.cn/20190401193757525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2J1dHRlcmZseTEwMDk=,size_16,color_FFFFFF,t_70)

总结起来，依次经过了以下调用：
1. 调用HttpServlet.service(ServletRequest, ServletResponse)方法。
2. 调用FrameworkServlet.service(HttpServletRequest, HttpServletResponse)方法。
3. 调用HttpServlet.service(HttpServletRequest, HttpServletResponse)方法。
4. 调用FrameworkServlet.doXXX()方法。
5. 调用DispatcherServlet.doService()方法。
6. 调用DispatcherServlet.doDispatch()方法。

### doDispatch()方法包含了真正处理一个请求的核心逻辑，执行步骤
1. 根据已初始化的handlerMappings和request，获取该请求对应的HandlerExecutionChain对象，然后获得HandlerAdapter；
2. 依次调用HandlerExecutionChain维护的interceptors， 执行handlerInterceptor的preHandle()方法。这里需要强调的是，如果某个interceptor.preHandle()处理失败，就直接短路，所以handler是不会被执行的，而是通过exceptionResolver处理异常并返回给客户端；
3. 如果interceptor都执行成功，通过handlerAdaptors获取到该请求对应的HandlerAdaptor, 并执行handler；
4. 执行完毕后，执行interceptor.postHandle()方法，如果需要返回view, 则配置ModelAndView, 并渲染view对象。


# 一个项目中可以有多个dispatcherServelt吗？为什么？
可以，项目中有多个服务，为了对不同服务进行不同的配置管理，需要对不同服务设置不同的上下文，为了不覆盖默认的dispatcherServlet，必须指定一个别的名称。

https://cloud.tencent.com/developer/article/1337489


# 解决POST请求中文乱码问题，GET的又如何处理
（1）解决post请求乱码问题：
在web.xml中配置一个CharacterEncodingFilter过滤器，设置成utf-8；
```
<filter>

    <filter-name>CharacterEncodingFilter</filter-name>

    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>

    <init-param>

        <param-name>encoding</param-name>

        <param-value>utf-8</param-value>

    </init-param>

</filter>

<filter-mapping>

    <filter-name>CharacterEncodingFilter</filter-name>

    <url-pattern>/*</url-pattern>

</filter-mapping>
```
（2）get请求中文参数出现乱码解决方法有两个：

1. 修改tomcat配置文件添加编码与工程编码一致，如下：

`<ConnectorURIEncoding="utf-8" connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443"/>`

2. 另外一种方法对参数进行重新编码：

`String userName = new String(request.getParamter("userName").getBytes("ISO8859-1"),"utf-8")`

ISO8859-1是tomcat默认编码，需要将tomcat编码后的内容按utf-8编码。

# Spring MVC的异常处理 ？
可以将异常抛给Spring框架，由Spring框架来处理；我们只需要配置简单的异常处理器，在异常处理器中添视图页面即可。

# SpringMvc的控制器是什么?是不是单例模式 ？
控制器提供一个访问应用程序的行为，此行为通常通过服务接口实现。控制器解析用户输入并将其转换为一个由视图呈现给用户的模型。Spring用一个非常抽象的方式实现了一个控制层，允许用户创建多种用途的控制器。

是单例模式,所以在多线程访问的时候有线程安全问题,不要用同步,会影响性能的,解决方案是在控制器里面不能写字段。


# Spring MVC常用的注解
[见web相关注解](https://www.cnblogs.com/cashew/p/8991955.html)

# 怎样在方法里面得到Request,或者Session？
直接在方法的形参中声明request,SpringMvc就自动把request对象传入。
# 如果想在拦截的方法里面得到从前台传入的参数,怎么得到？
直接在形参里面声明这个参数就可以,但必须名字和传过来的参数一样。
# 如果前台有很多个参数传入,并且这些参数都是一个对象的,那么怎么样快速得到这个对象？
直接在方法中声明这个对象,SpringMvc就自动会把属性赋值到这个对象里面。

# SpringMvc后台的返回值是什么？
返回三种类型：
- ModelAndView 无敌的 带着数据 返回视图路径（返回视图时带着数据，一块返回） 不建议使用
- String 返回视图路径 model带数据（返回视图就是返回视图，数据是由model带回，视图和数据解耦） 官方推荐此种方式，解耦，数据和视图分离MVC 建议使用
- void ajax不需要跳转视图只需要返回数据 json格式数据 请求如果是ajax用次返回方式就比较合适 异步请求时使用

# SpringMvc用什么对象从后台向前台传递数据的？
通过ModelMap对象,可以在这个对象里面调用put方法,把对象加到里面,前台就可以通过el表达式拿到。

# 怎么样把ModelMap里面的数据放入Session里面？
可以在类上面加上@SessionAttributes注解,里面包含的字符串就是要放入session里面的key。


# 如何在Spring MVC中校验参数
Spring MVC 默认支持JSR-303校验规范 。并在Spring-Boot-starter-web中提供了JSR-303规范实现Hibernate Validator。我们可以使用它来进行参数校验。
[参数检验使用](https://www.cnblogs.com/cashew/p/12102858.html)

# 如何全局处理控制器异常？
通过@ControllerAdvice（也可使用@RestControllerAdvice）注解和@ExceptionHandler注解组合，通过在方法入参中捕获异常进行处理，举例如下：
```
@Slf4j
@RestControllerAdvice("cn.felord.manage.api")
public class GlobalExceptionControllerAdvice {

    @ExceptionHandler(NullPointerException.class)
    public Rest nullPointHandler(HttpServletRequest request, NullPointerException e) {
        log.error("空指针啦，赶紧关注公众号：Felordcn", e);
        return RestBody.failure(-1, "null point exception");
    }
}
```

# 如何处理Spring MVC 中的跨域问题？
Spring MVC 解决跨域问题主要有以下种办法：
- 通过Spring MVC 拦截器来处理，同理servlet中的filter也可以处理。
- 通过在控制层方法使用@CrossOrigin注解。 请注意该方案需要在Spring MVC 4.x 以上。
- 通过在Spring MVC xml配置文件中的<mvc:cors> 标签中配置。
- 通过WebMvcConfigurer#addCorsMappings(CorsRegistry)来配置。

# 如何格式化Spring MVC入参参数？
两种方式：
- 实现org.springframework.core.convert.converter.Converter<S,T> ，并将实现注入Spring容器中。
- 实现org.springframework.format.Formatter<T> ，并将实现注入Spring 容器中。

# SpringMVC的Controller是如何将参数和前端传来的数据一一对应的
@RequestParam注解

反射原理获取参数名字

HandlerAdapter在内部对于每个请求，都会实例化一个ServletInvocableHandlerMethod进行处理，ServletInvocableHandlerMethod在进行处理的时候，会分两部分别对请求跟响应进行处理。

https://www.cnblogs.com/fangjian0423/p/springMVC-request-param-analysis.html

可自己实现一个实现HandlerMethodArgumentResolver的类，配合自定义注解使用（用来做校验也可）。

# 拦截器
Spring Web MVC 的处理器拦截器类似于Servlet 开发中的过滤器Filter，用于对处理器进行预处理和后处理。
如：在进入action or controller之前先判断一下用户登没登陆：
![图](https://upload-images.jianshu.io/upload_images/4189525-8724bff50fd89b5b.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)
Spring MVC拦截器允许我们拦截客户端请求并在三个地方处理它————`在处理之前`，`处理之后`或`完成之后（在呈现视图时）`。
拦截器切面处理一些公共逻辑而避免重复处理程序代码（如日志记录），也可以用来更改Spring模型中全局使用的参数。

实现拦截效果有两步：
1. 拦截器定义：实现HandlerInterceptor接口或继承适配器类HandlerInterceptorAdapter
![图](https://upload-images.jianshu.io/upload_images/4189525-2a5aa0a6cbeecc56.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)
在preHandle方法中会选择放行不放行【返回true是放行，false是不放行】
2. 拦截器配置：在springmvc.xml中配置拦截器】
```
<mvc:interceptors>
    	<!-- 配置一个拦截器的Bean就可以了 默认是对所有请求都拦截 -->
    <bean id="myInterceptor" class="com.zwp.action.MyHandlerInterceptor"></bean>
    	<!-- 只针对部分请求拦截 -->
    <mvc:interceptor>
       <mvc:mapping path="/modelMap.do" />
       <bean class="com.zwp.action.MyHandlerInterceptorAdapter" />
    </mvc:interceptor>
</mvc:interceptors>
```
[使用例子](https://www.jianshu.com/p/95d695c10fd0)

# SpringMVC拦截器和过滤器区别
- 过滤器  
依赖于servlet容器，跟springmvc等框架并没有关系。在实现上基于函数回调，可以对几乎所有请求进行过滤，但是缺点是一个过滤器实例只能在容器初始化时调用一次。使用过滤器的目的是用来做一些过滤操作，获取我们想要获取的数据，比如：在过滤器中修改字符编码；在过滤器中修改HttpServletRequest的一些参数，包括：过滤低俗文字、危险字符等。

- 拦截器  
依赖于web框架，在实现上基于Java的反射机制，属于面向切面编程（AOP）的一种运用。由于拦截器是基于web框架的调用，因此可以使用Spring的依赖注入（DI）进行一些业务操作，同时一个拦截器实例在一个controller生命周期之内可以多次调用。但是缺点是只能对controller请求进行拦截，对其他的一些比如直接访问静态资源的请求则没办法进行拦截处理。

Filter里doFilter()方法里的代码就是从多个Servlet的service()方法里抽取的通用代码，通过使用Filter可以实现更好的复用。

Filter在只在Servlet前起作用。而拦截器能够深入到方法前后、异常抛出前后等，因此拦截器的使用具有更大的弹性。

# 项目中有多个拦截器或者过滤器，那么它们的执行顺序应该是什么样的
WebMvcConfigurer的配置顺序

@order()

带 @WebFilter本身是没有Order属性，所以构建的Filter将是默认的Order值，另外类名可决定注册Filter的顺序。


# 怎么编写一个web服务器
https://zhuanlan.zhihu.com/p/365626068

https://blog.csdn.net/turkeyzhou/article/details/5512348

https://segmentfault.com/a/1190000022667463

