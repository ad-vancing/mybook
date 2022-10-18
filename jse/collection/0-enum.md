
可以把 enum 看成是一个普通的 class，它们都可以定义一些属性和方法，不同之处是：enum 不能使用 extends 关键字继承其他类，因为 enum 已经继承了 java.lang.Enum（java是单一继承）。
创建枚举类型要使用 enum 关键字，隐含了所创建的类型都是 java.lang.Enum 类的子类（java.lang.Enum 是一个抽象类）

枚举类型的每一个值都将映射到 protected Enum(String name, int ordinal) 构造函数中，在这里，每个值的名称都被转换成一个字符串，并且序数设置表示了此设置被创建的顺序。

# enum 对象的常用方法
String name() 
返回此枚举常量的名称，在其枚举声明中对其进行声明。

int ordinal() 
返回枚举常量的序数（它在枚举声明中的位置，其中初始常量序数为零）。


static <T extends Enum<T>> T valueOf(Class<T> enumType, String name) 
返回带指定名称的指定枚举类型的枚举常量。
