# Flink 自定义source
实现SourceFunction接口；

继承RichSinkFunction类：  
MySQL sink，在open()方法中建立连接，这样不用每次invoke的时候都要建立连接和释放连接。


# flink 和 sparkstreaming 的区别
https://blog.csdn.net/b6ecl1k7BS8O/article/details/81350587

- 编程模型
  - 运行模型
  - 运行时各节点的角色
- 任务调度
  - DGA vs StreamGraph
- 时间机制
  - Spark Streaming 只支持处理时间，Structured streaming 支持处理时间和事件时间，同时支持 watermark 机制处理滞后数据。
- 容错及处理语义
- 背压

