# preface

工厂模式加反射机制
```
interface Fruit {
     public abstract void eat();
}
class Apple implements Fruit {
    public void eat(){
        System.out.println("Apple");
    }
}
class Orange implements Fruit {
    public void eat(){
        System.out.println("Orange");
    }
}
class Factory {
    public static Fruit getInstance(String ClassName) {
        Fruit f=null;
        try {
            f=(Fruit)Class.forName(ClassName).newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }
}
class Client {
    public static void main(String[] a) {
        Fruit f=Factory.getInstance("io.github.dunwu.spring.Apple");
        if(f!=null){
            f.eat();
        }
    }
}
```
## ioc 中的工厂模式
Spring通过这种控制反转（IoC）的设计模式，使一个对象依赖其它对象时会通过被动的方式传送进来（如某个对象被创建时，其依赖的实现类也会同时被注入），而不是通过手动创建这些类。  
可以把IoC看作是一个大工厂，只不过这个大工厂里要生成的对象都是在配置文件(XML)中给出定义的，然后利用Java的反射技术，根据XML中给出的类名生成相应的对象。  

从某种程度上来说，IoC相当于把在工厂方法里通过硬编码创建对象的代码，改变为由XML文件来定义，也就是把工厂和对象生成这两者独立分隔开来，目的就是提高灵活性和可维护性，更是达到最低的耦合度，因此我们要明白所谓为的IOC就将对象的创建权,交由Spring完成，从此解放手动创建对象的过程，同时让类与类间的关系到达最低耦合度。


## 面向接口的编程
https://blog.csdn.net/javazejian/article/details/54561302  
所有调用都通过接口来完成，而最终的执行者是接口的实现类，当替换实现类时，也只需修改接口指向新的实现类。

## 使用反射编程能解决项目开发的什么问题
反射是一种根据给出的完整类名（字符串方式）来动态地生成对象，这种编程方式可以**让对象在生成时才决定到底是哪一种对象**。  
因此可以在配置文件里写好接口实现类的完全限定名称，代码里通过读取配置文件的实现类完全限定名称，然后通过反射技术在**运行时动态生成该类**，最终赋值给接口，这样可以只需修改配置文件不用重新修改代码而达到替换接口实现类的目的。

# 什么是Spring IOC 容器
容器创建对象，将它们装配在一起，配置它们并管理它们的完整生命周期。    
对象的创建管理的控制权都交给了Spring容器，所以这是一种控制权的反转，称为IOC容器（而这里IOC容器不只是Spring才有，很多框架也都有该技术）。

Spring 容器使用依赖注入来管理组成应用程序的组件。    
容器通过读取提供的配置元数据来接收对象进行实例化，配置和组装的指令。    
该元数据可以通过 XML，Java 注解或 Java 代码(@Bean)提供。

# Spring 的 IoC 设计支持的功能
- 依赖注入
- 依赖检查
- 自动装配
- 支持集合
- 指定初始化方法和销毁方法
- 支持回调某些方法（但是需要实现 Spring 接口，略有侵入）

其中，最重要的就是依赖注入，从 XML 的配置上说，即 ref 标签。对应 Spring RuntimeBeanReference 对象。

对于 IoC 来说，最重要的就是容器。容器管理着 Bean 的生命周期，控制着 Bean 的依赖注入。

# 依赖注入 Dependency Injection
当一个bean实例引用到了另外一个bean实例时，spring容器帮助我们创建依赖bean实例并注入（传递）到另一个bean中。  
比如往类accountService对象中注入其他对象（accountDao）的操作称为依赖注入。  

在依赖注入中，您不必创建对象，但必须描述如何创建它们。  
您不是直接在代码中将组件和服务连接在一起，而是描述配置文件中哪些组件需要哪些服务，由 IoC 容器将它们装配在一起。

## set方法注入
被注入的属性需要有set方法。  
Setter注入时在bean实例创建完成后执行的。  
## 构造函数注入
通过构造方法注入依赖，构造函数的参数一般情况下就是依赖项，有多个时顺序并不重要。

接口注入（Spring 不用）

# 核心容器（spring context应用上下文) 模块
是基本的Spring模块，提供spring 框架的基础功能，BeanFactory 是 任何以spring为基础的应用的核心。Spring 框架建立在此模块之上，它使Spring成为一个容器。

Bean 工厂是工厂模式的一个实现，提供了控制反转功能，用来把应用的配置和依赖从真正的应用代码中分离。最常用的就是org.springframework.beans.factory.xml.XmlBeanFactory ，它根据XML文件中的定义加载beans。该容器从XML 文件读取配置元数据并用它去创建一个完全配置的系统或应用。


# ApplicationContext 和 BeanFactory
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221957939.png)
BeanFactory，像一个包含 bean 集合的工厂类。它会在客户端要求时实例化 bean。这是最简单的容器，只能提供基本的DI功能。所有的容器要么是BeanFactory的子类的实现，要么就是BeanFactory本身的实现。   

继承了BeanFactory后派生而来的ApplicationContext(应用上下文)，它能提供更多企业级的服务，例如解析配置文本信息等等，这也是ApplicationContext实例对象最常见的应用场景。  

## BeanFactory 
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221845554.png)
BeanFactory是IOC容器的核心接口，它的职责包括：实例化、定位、配置应用程序中的对象及建立这些对象间的依赖。  
BeanFactory只是个接口，并不是IOC容器的具体实现，但是Spring容器给出了很多种实现，如 DefaultListableBeanFactory、XmlBeanFactory、ApplicationContext等，通过BeanFactory获取IOC管理的bean。  

可以理解为就是个 HashMap，key为id值，value为对象。通常只提供注册（put），获取（get）这两个功能。我们可以称之为 “低级容器”。    
```
1.使用简单工厂模式来处理bean容器。  
2.解析xml文件，获取配置中的元素信息。  
3.利用反射获实例化配置信息中的对象。  
4.如果有对象注入，使用invoke()方法。  
5.实例化的对象放入bean容器中，并提供getBean方法。
```  
通过以上步骤就实现了spring的BeanFactory功能，只要在配置文件中配置好，实例化对象的事情交给BeanFactory来实现，用户不需要通过new对象的方式实例化对象，直接调用getBean方法即获取对象实例。  
参考：https://blog.csdn.net/mlc1218559742/article/details/52776160

## ApplicationContext 
 一般称BeanFactory为IoC容器，而称ApplicationContext为应用上下文。  
 BeanFactory定义了Bean初始化的流程，ApplicationContext还提供了更完整的框架功能（他继承了多个接口）：如继承MessageSource，因此支持国际化、统一的资源文件访问方式、提供在监听器中注册bean的事件、同时加载多个配置文件、载入多个（有继承关系）上下文 ，使得每一个上下文都专注于一个特定的层次，比如应用的web层。定义了从XML读取，到Bean初始化，再到使用的过程。  
 
 BeanFactroy采用的是**延迟加载**形式来注入Bean的，即只有在使用到某个Bean时(调用getBean())，才对该Bean进行加载实例化。这样，我们就不能发现一些存在的Spring的配置问题。如果Bean的某一个属性没有注入，BeanFacotry加载后，直至第一次使用调用getBean方法才会抛出异常。
 ApplicationContext，它是**即时加载**，在容器启动时，一次性创建了所有的Bean（ refresh 方法刷新整个容器，即重新加载/刷新所有的 bean）。这样，在容器启动时，我们就可以发现Spring中存在的配置错误，这样有利于检查所依赖属性是否注入。 ApplicationContext启动后预载入所有的单实例Bean，通过预载入单实例bean ,确保当你需要的时候，你就不用等待，因为它们已经创建好了。
 
 相对于基本的BeanFactory，ApplicationContext 唯一的不足是占用内存空间。当应用程序配置Bean较多时，程序启动较慢。
 
 BeanFactory通常以编程的方式被创建，ApplicationContext还能以声明的方式创建，如使用ContextLoader。
 
 BeanFactory和ApplicationContext都支持BeanPostProcessor、BeanFactoryPostProcessor的使用，但两者之间的区别是：BeanFactory需要手动注册，而ApplicationContext则是自动注册。  
 
 ##  ApplicationContext常用的实现类
 ![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305221955893.png)
- FileSystemXmlApplicationContext
    此容器从一个XML文件中加载beans的定义，XML Bean 配置文件的全路径名必须提供给它的构造函数。

- ClassPathXmlApplicationContext
    此容器也从一个XML文件中加载beans的定义，这里，你需要正确设置classpath因为这个容器将在classpath里找bean配置。

- WebXmlApplicationContext
    此容器加载一个XML文件，此文件定义了一个WEB应用的所有bean。
    
https://www.jianshu.com/p/2854d8984dfc
 
 ### 总结
 IoC 在 Spring 里，只需要低级容器就可以实现 ：
 加载配置文件，解析成 BeanDefinition 放在 Map 里。
 调用 getBean 的时候，从 BeanDefinition 所属的 Map 里，拿出 Class 对象进行实例化，同时，如果有依赖关系，将递归调用 getBean 方法 —— 完成依赖注入。
 上面就是 Spring 低级容器（BeanFactory）的 IoC。
 
 至于高级容器 ApplicationContext，他包含了低级容器的功能，当他执行 refresh 模板方法的时候，将刷新整个容器的 Bean。同时其作为高级容器，包含了太多的功能。一句话，他不仅仅是 IoC。他支持不同信息源头，支持 BeanFactory 工具类，支持层级容器，支持访问文件资源，支持事件发布通知，支持接口回调等等。

[参考1](https://javadoop.com/post/spring-ioc)  
[参考2](https://www.cnblogs.com/ToBeAProgrammer/p/5230065.html)


# Spring的IOC有什么优势 Inverse of Control
它促进了松耦合，这种方式使一个对象依赖其它对象时会通过被动的方式传送进来，而不是通过手动创建这些类。

Spring IOC 也是一个java对象，被创建后，可以进行对其他对象的控制包括对象的整个生命周期，包括**初始化**、**创建**、**销毁**等。  

通过 IoC 方式， 使得上层不再依赖于下层的接口，即通过采用一定的机制来选择不同的下层实现， 完成控制反转， 使得由调用者来决定被调用者。

我们通过配置文件配置了实现类的完全限定名称，然后利用反射在运行时创建实际实现类，Spring的IOC容器都会帮我们完成，**我们唯一要做的就是把需要创建的类和其他类依赖的类以配置文件的方式告诉IOC容器需要创建那些类和注入哪些类**即可。

# 源码
>Spring 中的 org.springframework.beans 包和 org.springframework.context 包构成了 Spring 框架 IoC 容器的基础。  

[参考](https://www.cnblogs.com/java-chen-hao/p/11113340.html)

## Spring IOC容器的初始化过程 
BeanDefinition

[参考1](https://www.cnblogs.com/tanghaorong/p/13497223.html)

[参考2](https://blog.csdn.net/u011043551/article/details/79675363)

# Spring动态加载数据源

