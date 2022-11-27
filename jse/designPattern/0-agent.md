![](https://img-blog.csdn.net/20180110161445049?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvY2hlbnl1bGFuY24=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

项目中使用哪些设计模式？（策略，模板，观察者）

https://louluan.blog.csdn.net/article/details/18847313?spm=1001.2014.3001.5502

# 代理模式
[参考](https://www.cnblogs.com/gonjan-blog/p/6685611.html)

demo:  假如一个班的同学要向老师交班费，但是都是通过班长把自己的钱转交给老师。这里，班长就是代理学生上交班费，
 
1. 创建一个Person接口。这个接口就是学生（被代理类），和班长（代理类）的公共接口，他们都有上交班费的行为

2. 创建Student类实现Person接口。Student可以具体实施上交班费的动作。

3. 创建StudentsProxy类，这个类也实现了Person接口，另外持有一个学生类对象，由于实现了Peson接口，同时持有一个学生对象，那么他可以代理学生类对象执行上交班费行为。

代理模式最主要的就是**有一个公共接口（Person），一个具体的类（Student），一个代理类（StudentsProxy）,代理类持有具体类的实例，代为执行具体类实例方法**。

代理模式就是在访问实际对象时引入一定程度的间接性，因为这种间接性，可以附加多种用途。比如在代理类中帮张三上交班费之前，执行其他操作，这种操作，也是使用代理模式的一个很大的优点。最直白的就是在Spring中的面向切面编程（AOP）。

**根据创建代理类的时间点**，又可以分为静态代理和动态代理。 上面是静态代理的例子，代理类(studentProxy)是自己定义好的，在程序运行之前就已经编译完成。
       
## 动态代理
代理类**在程序运行时创建**的代理方式被成为动态代理。 

优势在于可以很方便的对代理类的函数进行统一的处理，而不用修改每个代理类中的方法。

### jdk实现
在java的java.lang.reflect包下提供了一个Proxy类和一个InvocationHandler接口。动态代理中被代理对象和代理对象是通过InvocationHandler来完成的代理过程的

通过实现InvocationHandler接口创建StuInvocationHandler类，这个类中持有一个被代理对象的实例target。  
InvocationHandler中有一个invoke方法，所有执行代理对象的方法都会被替换成执行invoke方法。

#### 具体过程
[参考](https://blog.csdn.net/Trunks2009/article/details/123106582?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-123106582-blog-102808726.pc_relevant_multi_platform_whitelistv3&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-123106582-blog-102808726.pc_relevant_multi_platform_whitelistv3&utm_relevant_index=1)

jdk为我们的生成了一个叫`$Proxy0`（这个名字后面的0是编号，有多个代理类会一次递增）的代理类，这个类文件时放在内存中的，我们在创建代理对象时，就是通过反射获得这个类的构造方法，然后创建的代理实例。通过对这个生成的代理类源码的查看，我们很容易能看出，动态代理实现的具体过程。

我们可以对InvocationHandler看做一个中介类，中介类持有一个被代理对象，在invoke方法中调用了被代理对象的相应方法。通过聚合方式持有被代理对象的引用，把外部对invoke的调用最终都转为对被代理对象的调用。

代理类调用自己方法时，通过自身持有的中介类对象来调用中介类对象的invoke方法，从而达到代理执行被代理对象的方法。也就是说，动态代理通过中介类实现了具体的代理功能。

### 使用jdk创建动态代理
1. 创建实例对象即代理对象如zhangsan
2. 创建一个与代理对象相关联的InvocationHandler
3. 使用Proxy.newProxyInstance 创建代理对象stuProxy来代理zhangsan，代理对象的每个执行方法都会替换执行InvocationHandler中的invoke方法

### 为什么jdk动态代理需要接口?

```
Proxy.newProxyInstance(targetObject.getClass().getClassLoader(), targetObject.getClass().getInterfaces(), this);
```

生成的代理类：`$Proxy0 extends Proxy implements Person`，我们看到代理类继承了Proxy类，所以也就决定了java动态代理只能对接口进行代理，Java的继承机制注定了这些动态代理类们无法实现对class的动态代理。

### cglib实现
cglib 底层实现依赖于 ASM，一个 Java 字节码操控框架。它能够以二进制形式修改已有类或者动态生成类。ASM 可以直接产生二进制 class 文件，也可以在类被加载入 Java 虚拟机之前动态改变类行为。ASM 从类文件中读入信息后，能够改变类行为，分析类信息，甚至能够根据用户要求生成新类。  
   
通过字节码技术为一个类创建子类，并**在子类中采用方法拦截的技术拦截所有父类方法的调用，顺势织入横切逻辑**。  

创建一个继承实现类的子类，用字节码处理框架ASM动态修改子类的代码来实现的，所以可以用传入的类引用执行代理类。  

[参考](https://blog.csdn.net/luanlouis/article/details/24589193)

```
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
```



