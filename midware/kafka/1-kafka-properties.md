# Broker 端参数（需要修改默认值的参数）

- log.dirs=/home/kafka1,/home/kafka2,/home/kafka3  
最好保证这些目录挂载到不同的物理磁盘上，这样可以提升读写性能、实现故障转移（Failover，坏掉的磁盘上的数据会自动地转移到其他正常的磁盘上，而且 Broker 还能正常工作。）


##  ZooKeeper 相关

- zookeeper.connect=zk1:2181,zk2:2181,zk3:2181/kafka1  
注意 chroot 只需要写一次，而且是加到最后的。


## Broker 连接相关
- listeners：学名叫监听器  
告诉外部连接者要通过什么协议访问指定主机名和端口开放的 Kafka 服务。 
- advertised.listeners=PLAINTEXT://your.host.name:9092  
Advertised 的含义表示宣称的、公布的，就是说这组监听器是 Broker 用于对外发布的。  
>协议名称可能是标准的名字，比如 PLAINTEXT 表示明文传输、SSL 表示使用 SSL 或 TLS 加密传输等；也可能是你自己定义的协议名字，比如`CONTROLLER: //localhost:9092`。

>一旦你自己定义了协议名称，你必须还要指定listener.security.protocol.map参数告诉这个协议底层使用了哪种安全协议，比如指定listener.security.protocol.map=CONTROLLER:PLAINTEXT表示CONTROLLER这个自定义协议底层使用明文不加密传输数据。


##  Topic 管理
- auto.create.topics.enable：是否允许自动创建 Topic。  
建议最好设置成 false

- unclean.leader.election.enable：是否允许 Unclean Leader 选举。  
如果设置成 false，那么就坚持之前的原则，坚决不能让那些落后太多的副本竞选 Leader。这样做的后果是**这个分区就不可用**了，因为没有 Leader 了。反之如果是 true，那么 Kafka 允许你从那些“跑得慢”的副本中选一个出来当 Leader。这样做的后果是**数据有可能就丢失**了，因为这些副本保存的数据本来就不全，当了 Leader 之后认为自己的数据才是权威的。
>这个参数在最新版的 Kafka 中默认就是 false，但社区对这个参数的默认值来来回回改了好几版了，鉴于这个不确定性建议还是显式地把它设置成 false 吧。

- auto.leader.rebalance.enable：是否允许定期进行 Leader 选举。  
设置它的值为 true 表示允许 Kafka 定期地对一些 Topic 分区进行 Leader 重选举（严格来说它与上一个参数中 Leader 选举的最大不同在于，它不是选 Leader，而是换 Leader！）建议设置成 false。
                                                                                                          
## 数据留存
- log.retention.{hour|minutes|ms}：这是个“三兄弟”，都是控制一条消息数据被保存多长时间。  
从优先级上来说 ms 设置最高、minutes 次之、hour 最低。

- log.retention.bytes：这是指定 Broker 为消息保存的总磁盘容量大小。  
值默认是 -1，表明你想在这台 Broker 上保存多少数据都可以。
>在云上构建多租户的 Kafka 集群：设想你要做一个云上的 Kafka 服务，每个租户只能使用 100GB 的磁盘空间，为了避免有个“恶意”租户使用过多的磁盘空间，设置这个参数就显得至关重要了。

ps:上面满足任何一个就会开始删除消息。

- message.max.bytes：控制 Broker 能够接收的最大消息大小。  
默认的 1000012 太少了，还不到 1MB。

# Topic 级别参数
 Kafka 也支持为不同的 Topic 设置不同的参数值，Topic 级别参数会覆盖全局 Broker 参数的值，而每个 Topic 都能设置自己的参数值，这就是所谓的 Topic 级别参数。

创建 Topic 时进行设置或修改 Topic 时设置。  
`bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topictransaction --partitions 1 --replication-factor 1 --config retention.ms=15552000000 --config max.message.bytes=5242880`

`bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topictransaction --partitions 1 --replication-factor1 --config retention.ms=15552000000 --config max.message.bytes=5242880`

- retention.ms：规定了该 Topic 消息被保存的时长。默认是 7 天，即该 Topic 只保存最近 7 天的消息。一旦设置了这个值，它会覆盖掉 Broker 端的全局参数值。
- retention.bytes：规定了要为该 Topic 预留多大的磁盘空间。和全局参数作用相似，这个值通常在多租户的 Kafka 集群中会有用武之地。当前默认值是 -1，表示可以无限使用磁盘空间。 
 
>还要修改 Broker的 replica.fetch.max.bytes 保证复制正常
 消费还要修改配置 fetch.message.max.bytes
 
 
# JVM 参数
- KAFKA_HEAP_OPTS 堆大小  
默认的 Heap Size 来跑 Kafka，说实话默认的 1GB 有点小，通用的建议：将你的 JVM 堆大小设置成 6GB。  
>毕竟 Kafka Broker 在与客户端进行交互时会在 JVM 堆上创建大量的 ByteBuffer 实例，Heap Size 不能太小。

虽然无脑推荐6GB，但绝不是无脑推荐>6GB。一个16GB的堆Full GC一次要花多长时间啊，所以我觉得6GB可以是一个初始值，你可以实时监控堆上的live data大小，根据这个值调整heap size。

另外堆越小留给页缓存的空间也就越大，这对Kafka是好事。  
 
- KAFKA_JVM_PERFORMANCE_OPTS 垃圾回收器  

在启动 Kafka Broker 之前，先设置上这两个环境变量：
```
$> export KAFKA_HEAP_OPTS=--Xms6g  --Xmx6g
$> export  KAFKA_JVM_PERFORMANCE_OPTS= -server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true
$> bin/kafka-server-start.sh config/server.properties

```
 