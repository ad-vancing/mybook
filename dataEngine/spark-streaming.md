https://spark.apache.org/

# 背压机制 backpressur
写入数据比较慢，但是可读流又在不断的传输数据，就会造成内存溢出，形成阻塞。

Spark Streaming 从v1.5开始引入反压机制（back-pressure）,通过动态控制数据接收速率来适配集群数据处理能力。

通过属性`spark.streaming.backpressure.enabled`来控制是否启用backpressure机制，默认值false。根据JobScheduler反馈作业的执行信息来动态调整Receiver数据接收率。



# join
Spark Streaming中有四个join分别是join、leftOuterJoin、rightOuterJoin、fullOuterJoin



## 两个流的数据是怎么在同一个sparkstreaming 中拿到
保留全部数据使用 fullOuterJoin。

由于，这两个流的数据不一定是同时到达，需要对数据做缓存处理 redis
https://blog.csdn.net/qq_41858402/article/details/109256977

# structured streaming
https://blog.csdn.net/weixin_45366499/article/details/111545564