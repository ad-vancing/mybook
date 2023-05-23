# kafka服务搭建
http://kafka.apache.org/quickstart
server.properties文件，指定本机地址host.name，指定broker.id与zk的myid一致，日志存储路径log.dirs配置，指定zk服务zookeeper.connect。端口号默认9092。

后台启动`bin/kafka-server-start.sh -daemon config/server.properties` ，集群逐个启动。

推荐kafka集群监管工具kafka manager。https://github.com/yahoo/kafka-manager
下载后使用sbt编译，配置zk，9000端口访问界面。
ProdServerStart是它的进程名。

```
$> export KAFKA_HEAP_OPTS=--Xms6g  --Xmx6g
$> export  KAFKA_JVM_PERFORMANCE_OPTS= -server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true
$> bin/kafka-server-start.sh config/server.properties
```

# shell
测试：
在生产数据窗口写数据，看消费数据窗口是否可以接收
通过控制台生产数据:`$bin/kafka-console-producer.sh --broker-list kafka1:9092 --topic test`
在另一个窗口，消费数据:`$bin/kafka-console-consumer.sh --zookeeper zk1:2181 --topic test --from-beginning`
JAVA 消费者默认为latest。

推荐使用 --bootstrap-server 而非 --zookeeper 以后会有越来越少的命令和 API 需要与 ZooKeeper 进行连接。

## topic 管理
`$bin/kafka-topics.sh --bootstrap-server broker_host:port --list`

`$bin/kafka-topics.sh --bootstrap-server broker_host:port --describe --topic <topic_name>`


创建topic：
`$bin/kafka-topics.sh --create --zookeeper 192.168.180.221:2181,192.168.180.222:2181,192.168.180.223:2181  --replication-factor 1 --partitions 3 --topic HYPT_GNSS`

删除topic：
`$bin/kafka-topics.sh -delete -zookeeper 192.168.180.221:2181 -topic HYPT_TEST`  
若配置文件server.properties没有配置delete.topic.enable = true,那么只是把topic标记为：marked for deletion
继续删除，进入zk客户端：
`$bin/zkCli.sh -server 192.168.180.221:2181`
进入`/admin/delete_topics`目录下，找到删除的topic,删除对应的信息(faile)
`ls /admin/delete_topics/HYPT_GNSS`
`ls /brokers/topics`
`rmr /brokers/topics/HYPT_GNSS`
ps：查看集群id`ls /brokers/ids`

topic增加分区：
`$bin/kafka-topics.sh --bootstrap-server broker_host:port --alter --topic <topic_name> --partitions < 新分区数 >`

修改主题级别参数（还是使用 --zookeeper）:
`$bin/kafka-configs.sh --zookeeper zookeeper_host:port --entity-type topics --entity-name <topic_name> --alter --add-config max.message.bytes=10485760`

修改主题限速，指设置 Leader 副本和 Follower 副本使用的带宽：
`$bin/kafka-configs.sh --zookeeper zookeeper_host:port --alter --add-config 'leader.replication.throttled.rate=104857600,follower.replication.throttled.rate=104857600' --entity-type brokers --entity-name 0`

看消费者组的消费情况：
`$bin/kafka-consumer-groups.sh --bootstrap-server kafka1:2181 kafka2:2181 kafka3:2181 --describe --group test-consumer-group`