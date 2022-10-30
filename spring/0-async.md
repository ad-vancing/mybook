# 使用
配置类上添加 @EnableAsync 注解  
需要异步执行的方法的所在类由Spring管理  
需要异步执行的方法上添加了 @Async 注解  


https://zhuanlan.zhihu.com/p/92035904  
https://www.cnblogs.com/wlandwl/p/async.html#4887733

# @EnableAsync干了什么
1、@EnableAsync 开启spring异步执行器 ，通过`@Import(AsyncConfigurationSelector.class)`向容器中注册了一个 ProxyAsyncConfiguration， ProxyAsyncConfiguration类构造一个bean（类型：AsyncAnnotationBeanPostProcessor）
默认情况下spring会先搜索TaskExecutor类型的bean或者名字为taskExecutor的Executor类型的bean,都不存在使用SimpleAsyncTaskExecutor执行器

可自己定义执行器，使用`@Async("taskExecutor")`：
```
@Configuration
public class AsyncConfig {

    private static final int MAX_POOL_SIZE = 50;

    private static final int CORE_POOL_SIZE = 20;

    @Bean("taskExecutor")
    public AsyncTaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        taskExecutor.setMaxPoolSize(MAX_POOL_SIZE);
        taskExecutor.setCorePoolSize(CORE_POOL_SIZE);
        taskExecutor.setThreadNamePrefix("async-task-thread-pool");
        taskExecutor.initialize();
        return taskExecutor;
    }
}
```


2、 从 AsyncAnnotationBeanPostProcessor 这个类的bean的生命周期走：
AOP-Advisor切面初始化（setBeanFactory()）--》AOP-生成代理类AopProxy（postProcessAfterInitialization()）--》AOP-切点执行（InvocationHandler.invoke）

Spring容器启动初始化bean时，判断类中是否使用了@Async注解，创建切入点和切入点处理器，根据切入点创建代理，在调用@Async注解标注的方法时，会调用代理，执行切入点处理器invoke方法，将方法的执行提交给线程池，实现异步执行。

https://cloud.tencent.com/developer/article/1426027

# @Async注解导致的循环依赖
解决AOP对象间循环依赖的核心方法是三级缓存    
加一个@Lazy注解即可  
https://developer.aliyun.com/article/768513

# 返回值
入参随意，但返回值只能是void或者Future.(ListenableFuture接口/CompletableFuture类)  
1）返回值：不要返回值直接void；需要返回值用AsyncResult或者CompletableFuture，如 ` return new AsyncResult<>(deviceAbilityMap);`
2）可自定义执行器并指定例如：@Async("otherExecutor")  
3）@Async  必须不同类间调用： A类--》B类.C方法()（@Async注释在B类/方法中）。如果在同一个类中调用，会变同步执行,例如:A类.B()-->A类.@Async C()，原因是：底层实现是代理对注解扫描实现的，B方法上没有注解，没有生成相应的代理类。(当然把@Async加到类上也能解决但所有方法都异步了，一般不这么用！)
![图](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/7/15/16bf46cb6008e824~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

延伸开来就是：
在同一个类中，一个方法调用同类中的其他有注解的方法注解是不会生效的！


```
        AnnotationConfigApplicationContext ac = new AnnotationConfigApplicationContext(Config.class);
        DmzAsyncService bean = ac.getBean(DmzAsyncService.class);
        bean.testAsync();
        System.out.println("main函数执行完成");
```

# 使用demo
https://www.jianshu.com/p/49b9d15456d9

# Quartz是如何完成定时任务的。自定义注解的实现。