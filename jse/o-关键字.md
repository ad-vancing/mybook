# abstract
它修饰的方法：  
只有声明，没有实现，需要子类继承实现。不能是final或static
任何继承抽象类的子类必须实现父类的所有抽象方法，除非该子类也是抽象类。
抽象方法的声明以分号结尾，例如：public abstract sample();

# final
final 通常代表不能被改变的。

- 与static一起修饰属性成为静态常量，会分配一段固定的存储空间
- 不使用static，与类实例化相关，初始化后就不会被改变，成为常量。
如果是基本类型的常量，编译器可以把常量带入计算中在 Java 中，提高一些性能。  
对于基本类型，final 使数值恒定不变。当用 final 修饰非基本类型对象时，final 只能保持对象引用恒定不变

final 修饰的函数参数表示在方法中不能改变参数对象引用或基本变量，主要用于匿名内部类的数据传递。

- 修饰方法
防止子类覆写该方法；
性能。编译器把对被 final修饰的方法的调用转化为内嵌调用，不必进栈出栈。

- final String  
https://www.cnblogs.com/xiaobingzi/p/10819884.html

java8特殊的：
https://blog.csdn.net/f641385712/article/details/81286231

## 匿名内部类使用外部变量为什么必须是final修饰的
方法内部类或匿名内部类，不包含静态内部类和成员内部类

保证了数据的同步。

java编译器则会在内部类内生成一个外部变量的拷贝，不是final,就无法保证:复制品与原始变量保持一致了,因为在方法中改的是原始变量,而局部内部类中改的是复制品。

在Java8 中，被局部内部类引用的局部变量，默认添加final，所以不需要添加final关键词

# 四种修饰符的限制范围
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/8412c55c-1138-40aa-bf8d-1087b59ff4f8/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220913%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220913T052647Z&X-Amz-Expires=86400&X-Amz-Signature=9628383478a316d14fda66eb04f99d45a0875aa21fc98c4f531b6265d30af30a&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22&x-id=GetObject)


# 接口和抽象类的区别，注意JDK8的接口可以有实现

- 接口和抽象类的区别，注意JDK8的接口可以有实现
    
    1.构造方法
    虽然抽象类和接口都不能直接实例化
    抽象类可以有构造方法，接口中不能有构造方法。
    
    2.成员变量
    接口的成员变量都是public static final，且必须赋初始值。没有私有的变量
    抽象类可以有普通成员变量（私有的变量，）。
    
    3.方法
    接口的方法都是public abstract 的，是专门给人重写的。
    接口里的所有方法都没有方法体，只能做方法申明（抽象方法）。
    接口中不能包含静态方法。
    
    抽象类是可以有私有的方法。
    抽象类中可以做方法申明（抽象方法），也可以做方法实现。
    抽象类里可以没有抽象方法。
    抽象类中可以包含静态方法（非抽象方法）。
    （abstract不能修饰属性）
    
    4、使用
    接口强调特定功能的实现，“has-a”关系；
    抽象类强调所属关系，"is a"，与匿名内部类配合使用
    接口表示一种能力，功能或者约定。
    eg:防盗门，继承门这个抽象类，实现锁这个接口。
    防盗门 is a 门，has a 锁。