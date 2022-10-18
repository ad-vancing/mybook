编写代码的时候是依赖commons-logging的接口编写的，当运行起来的时候就会去classpath中寻找相关的实现类，如果没有的话就会报错，加入log4j或者其他的日志框架都可以的。这就是面向接口编程的最好例子

log4j的组件
主要有三个组件，分别是 Logger，Appender和Layout，理解了，使用起来也不困难。Logger就是日志器，我们只要调用这个类的接口进行使用。appender是用来指定日志输出到哪里的，可以是控制台，文件等。layout就是格式化日志信息了，可以是文本文件的格式化，也可以是html网页文件的格式化。

日志的使用都比较简单，基本上是拿到一个对象引用就可以了，如：
```
Logger logger = LogFactory.getLog(TestBean.class);

```

properties文件，也可以是xml，我们一般使用properties的。
```
log4j.rootLogger=ERROR,stdout,fileout

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=[%d{yyyy-MM-dd HH:mm:ss:SSS}][%C:%M] %m%n

log4j.appender.fileout=org.apache.log4j.DailyRollingFileAppender
log4j.appender.fileout.File=${webapp.root.clk}/logs/clk 
log4j.appender.fileout.DatePattern=yyyy-MM-dd'.html'
log4j.appender.fileout.layout=org.apache.log4j.HTMLLayout

log4j.logger.org.xhome.clk=INFO
log4j.logger.org.xhome.clk.intercept=ERROR

```