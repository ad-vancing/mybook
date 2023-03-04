[菜鸟教程](https://www.runoob.com/java/java-examples.html)

## &与&&的区别
&和&&都可以用作逻辑与的运算符，表示逻辑与（and），当运算符两边的表达式的结果都为true时，整个运算结果才为true，否则，只要有一方为false，则结果为false。
**&&还具有短路的功能**，即如果第一个表达式为false，则不再计算第二个表达式，例如，对于if(str != null && !str.equals(“”))表达式，当str为null时，后面的表达式不会执行，所以不会出现NullPointerException如果将&&改为&，则会抛出NullPointerException异常。If(x==33 & ++y>0) y会增长，If(x==33 && ++y>0)不会增长
**&还可以用作位运算符**，当&操作符两边的表达式不是boolean类型时，&表示按位与操作，我们通常使用0x0f来与一个整数进行&运算，来获取该整数的最低4个bit位，例如，0x01 & 0x0f的结果为0x01。


## native
native方法表示该方法要用另外一种依赖平台的编程语言实现的，不存在着被子类实现的问题，所以，它也不能是抽象的，不能与abstract混用。例如，FileOutputSteam类要硬件打交道，底层的实现用的是操作系统相关的api实现，例如，在windows用c语言实现的，所以，查看jdk 的源代码，可以发现FileOutputStream的open方法的定义如下：
private native void open(String name) throws FileNotFoundException;
如果我们要用java调用别人写的c语言函数，我们是无法直接调用的，我们需要按照java的要求写一个c语言的函数，又我们的这个c语言函数去调用别人的c语言函数。由于我们的c语言函数是按java的要求来写的，我们这个c语言函数就可以与java对接上，java那边的对接方式就是定义出与我们这个c函数相对应的方法，java中对应的方法不需要写具体的代码，但需要在前面声明native。


#jse知识汇
https://developer.aliyun.com/ask/123515?spm=a2c6h.13159736

## theory basic
为什么int、float都是4个字节，short还能表示小数，但范围比int大(甚至比long表示的范围还大)，精度(即能精确表达的位数，超过就被截肢了)又比int低呢?
https://blog.csdn.net/c2681595858/article/details/84865920

long类型能自动转为float类型吗？
char类型和short类型做运算，得到是结果是什么类型？ 和byte呢？ byte和byte呢？int


# code 习惯：
https://xwjie.github.io/rule/function.html#%E6%8A%8A%E5%8F%AF%E8%83%BD%E5%8F%98%E5%8C%96%E7%9A%84%E5%9C%B0%E6%96%B9%E5%B0%81%E8%A3%85%E6%88%90%E5%87%BD%E6%95%B0