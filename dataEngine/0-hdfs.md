# hdfs数据读写流程
https://blog.csdn.net/qq_17685725/article/details/123243677


# 小文件
## 小文件怎么产生的
1. 数据源本身就是大量的小文件；
2. 动态分区插入数据，产生大量的小文件，从而导致 map 数量剧增；
3. reduce 数量越多，小文件也越多，reduce 的个数和输出文件个数一致；

## 小文件有什么问题
### nn内存
HDFS 中文件元信息（位置，大小，分块等）保存在 NameNode 的内存中，每个对象大约占用150 字节，如果小文件过多，会占用大量内存。
q：128G能存储多少文件块？   
`128 * 1024*1024*1024byte/150字节 = 128/150 * 2^30 = 0.9 * 10^9 = 9亿`

延伸影响：  
1、当 NameNode 重新启动时，它必须从本地磁盘上的缓存中读取每个文件的元数据，这意味要从磁盘读取大量的数据，会导致启动时间延迟。  
2、NameNode 必须不断跟踪并检查群集中每个数据块的存储位置。这是通过监听数据节点来报告其所有数据块来完成的。数据节点必须报告的块越多，它将消耗的网络带宽就越多。

### MapReduce 性能
原因1:大量的小文件意味着大量的随机磁盘 IO。

原因2:一个文件会启动一个 map，所以小文件越多，map 也越多，一个 map 启动一个 jvm 去执行，这些任务的初始化、启动、执行会浪费大量的资源，严重影响性能。

## 如何解决小文件问题
- 原则：  
输入合并，在 Map 前合并小文件（CombineFileInputFormat）；  
输出合并，在输出结果的时候合并小文件，如 开启map端的聚合；  
控制 reduce 个数来实现减少小文件个数。

- 其他：  
将众多的小文件打包成一个 HAR 文件  
将mapreduce输出不直接写hdfs，而是写入到hbase中  
参考：https://zhuanlan.zhihu.com/p/387760165

- JVM重用  
小文件场景开启JVM重用。JVM重用可以使得JVM实例在同一个job中重新使用N次，N的值可以在Hadoop的mapred-site.xml文件中进行配置。通常在10-20之间。
（如果没有小文件，不要开启JVM重用，因为会一直占用使用到的task卡槽，直到任务完成才释放）。  
`set mapred.job.reuse.jvm.num.task=10;`  
默认是1，表示一个JVM上最多可以顺序执行的task数目（属于同一个Job）是1。也就是说一个task启一个JVM。  
为每个task启动一个新的JVM将耗时1秒左右，对于运行时间较长（比如1分钟以上）的job影响不大，但如果都是时间很短的task，那么频繁启停JVM会有开销。  
https://blog.csdn.net/javastart/article/details/76724271

- flume  
如果数据是通过flume采集过来的，flume的 hdfs sink配置3个参数，生成的文件的滚动策略，这样可以避免小文件的产生。  

- hive    
sql、服务参数

# [HDFS常用操作指令](https://zhuanlan.zhihu.com/p/35763843)

https://segmentfault.com/a/1190000019114235

# [用户权限](https://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)


# hadoop单机安装hive
参考：  
[centos下Hadoop3.1.2安装 第一部分](https://blog.csdn.net/xuexijava85/article/details/99614900)

[Centos7 单机版搭建Hadoop3.1.2 第二部分](https://blog.csdn.net/qq_37497275/article/details/102400144)