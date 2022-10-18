# 为什么jdk动态代理需要接口?
https://blog.csdn.net/Trunks2009/article/details/123106582?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-123106582-blog-102808726.pc_relevant_multi_platform_whitelistv3&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-123106582-blog-102808726.pc_relevant_multi_platform_whitelistv3&utm_relevant_index=1
```
Proxy.newProxyInstance(targetObject.getClass().getClassLoader(), targetObject.getClass().getInterfaces(), this);
```

生成的代理对象需要把 InvocationHandler 实现类和 被代理类 两个东西关联在一起，由于已经继承了proxy类，java不能同时继承两个类，所以想要代理的类建立联系，只能实现同一个接口;


JDK主要会做以下工作：

1.   获取 RealSubject上的所有接口列表；
2.   确定要生成的代理类的类名，默认为：com.sun.proxy.$ProxyXXXX ；

3.   根据需要实现的接口信息，在代码中动态创建 该Proxy类的字节码；

4 .  将对应的字节码转换为对应的class 对象；

5.   创建InvocationHandler 实例handler，用来处理Proxy所有方法调用；

6.   Proxy 的class对象 以创建的handler对象为参数，实例化一个proxy对象


cglib 创建某个类A的动态代理类的模式是：

1.   查找A上的所有非final 的public类型的方法定义；

2.   将这些方法的定义转换成字节码；

3.   将组成的字节码转换成相应的代理的class对象；

4.   实现 MethodInterceptor接口，用来处理 对代理类上所有方法的请求（这个接口和JDK动态代理InvocationHandler的功能和角色是一样的）
————————————————
版权声明：本文为CSDN博主「亦山」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/luanlouis/article/details/24589193



