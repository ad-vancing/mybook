# Mybatis如何找到指定的Mapper的，如何完成查询的
https://blog.csdn.net/qq_18975791/article/details/99190110

MapperRegistry：addMappers()，getMapper()


## 使用 Mybatis 时，调用 DAO（Mapper）接口时是怎么调用到 SQL 的
动态代理+工厂bean。

spring的扩展后,在启动的时候,spring按规则扫描mybatis的xml,并解析最后生成了一个代理对象存入spring中以供使用。

MapperScannerBeanDefinitionParser 通过配置文件告诉spring去哪里找到mapper，

通用的类MapperFactoryBean，getObject返回的MapperProxy动态代理类。

https://blog.csdn.net/Jesse_cool/article/details/89186659

https://blog.csdn.net/ruanjian1111ban/article/details/91347824

# Mybatis中二级缓存和一级缓存的区别
https://blog.csdn.net/banzhuanhu/article/details/110201816

一级缓存的作用域是一个sqlsession内；

二级缓存作用域是针对mapper进行缓存；

# Mybatis初始化和执行原理
https://zhuanlan.zhihu.com/p/97879019