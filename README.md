# Introduction
雕虫小技

# java

## mark

[OpenJDK和Oracle JDK有什么区别和联系](https://blog.csdn.net/bisal/article/details/104832084/)

>高版本的 JDK 能向下兼容以前版本的 Class 文件，但不能运行以后版
本的 Class 文件，即使文件格式并未发生任何变化，虚拟机也必须拒绝执行超过其版本号的 Class 文件。

[intellij_idea使用指南](https://www.w3cschool.cn/intellij_idea_doc/intellij_idea_doc-rif12e7d.html)

## tool
JHSDB 是一款基于服务性代理实现的进程外调试工具
athas

>以前是以为欧洲人有现代科学的思想，才有了工业革命，其实，是因为他们殖民扩张，需要科技支撑他们的轻工业生产。所以这些问题也需要从场景需求考虑，才能深入理解其本质。

# 大纲
## jse
- [基本数据类型](https://www.cnblogs.com/xiaobingzi/p/9683412.html)

- oop的东西（封装、继承、多态）


- 集合（HashMap源码之类的）
1）它实现了什么接口？
2）有哪些常量？默认值
3）怎么实现key不重复的？
比较器
4）什么情况下会出现快速异常，为什么？怎么解决？
5）怎么保证线程安全？

- jvm

- 值引用，对象引用

- classloader

- 反射

- 设计模式（单例、装饰器、适配器）

## web
- http 请求

- tcp

- 浏览器工作原理

- nio

## db
- 事务

- 调优

- sql编写（去重、连接）

## spring
- mvc原理

- spring ioc&aop

- springboot

- springcloud 微服务

## redis
- 分布式锁

- 原理

- 不弄过滤器

## mq
- 丢消息

## ❓


[想做这种gitbook](https://troywu0.gitbooks.io/spark/content/java%E5%AF%B9%E8%B1%A1%E5%88%9B%E5%BB%BA%E7%9A%84%E8%BF%87%E7%A8%8B.html)

一些问号：
抽象类ClassLoader中，loadClass(String name, boolean resolve)方法里使用了（锁对象的）同步代码快，被实现类重写后，就失效了？

ConcurrentHashMap<String, Object> parallelLockMap;在ClassLoader中是怎么使用的？


# 资料
[何苦呢？](https://blog.csdn.net/qq_35854212/article/details/103144496)
## git项目
[电商](https://github.com/macrozheng/mall)

https://github.com/fantasticmaker

funny project
https://gitee.com/ainilili/ratel

https://zh.wikipedia.org/wiki/AWK

[b站程序员](https://live.bilibili.com/21907556)

[idea easy code](https://blog.csdn.net/qq_38225558/article/details/84479653)

## 还行的技术博客
[并发编程](http://ifeve.com/java-threadpool/)

[并发编程2](https://www.cnblogs.com/corvey/p/8478801.html)

[并发编程3](https://www.cnblogs.com/waterystone/p/4920797.html)

[JUC](https://www.cnblogs.com/linkworld/p/7819270.html)

[nio](https://www.iteye.com/blog/zhangshixi-679959)

[mybatisplus](https://www.jianshu.com/p/07be9ccb3306)

[mybatis](https://www.cnblogs.com/yixiu868/category/944649.html)

[文件上传](https://www.cnblogs.com/yixiu868/p/6365937.html)

[shiro](https://www.cnblogs.com/xuxinstyle/p/9674816.html)

[个人博客1](https://blog.ljyngup.com/page/3/)

[个人博客2数据结构c](https://www.cnblogs.com/darkchii/p/9070175.html)

[git学习](https://git-scm.com/book/zh/v1/Git-%E5%9F%BA%E7%A1%80-%E6%89%93%E6%A0%87%E7%AD%BE)

有些东西，学到不一定能用到，但到你需要用到的时候再去学，很可能就来不及了。


[JavaFamily](https://github.com/AobingJava/JavaFamily)  
https://github.com/rongweihe/CS_Offer

https://github.com/CyC2018/CS-Notes
  
https://github.com/Zeb-D/my-review

https://github.com/ZhongFuCheng3y/athena


# 刷题巩固
https://zhuanlan.zhihu.com/p/79224082

https://www.mianshi.online/

知识储备固然重要，但是精通才是更重要的，东西不再多在于精。