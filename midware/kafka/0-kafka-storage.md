# Kafka 存储机制
Kafka 采用 Logging（日志文件）这种原始的方式来存储消息。

>[为什么不用数据库或者 KV 来做存储？Append Only Data Structures 经典的底层存储原理](https://mp.weixin.qq.com/s?__biz=MzU2MTM4NDAwMw==&mid=2247491168&idx=1&sn=bd37f96692b3f7cecdaf3172abdb7a8c&chksm=fc78c14ccb0f485a451f70c7ffbf5b05d0f500dfef6321703e7cdebdc0de902d9d77a547d469&scene=178&cur_album_id=1763234202604388353#rd)

为了防止 log 文件(与每个分区对应)过大导致数据定位效率低下，Kafka 采取了**分片**和**稀疏索引机制**。 

[参考](https://mp.weixin.qq.com/s?__biz=Mzg3MTcxMDgxNA==&mid=2247488841&idx=1&sn=2ea884012493403ab45b450271708fc8&source=41#wechat_redirect)

## Partition 分区策略
先通过 Topic 对消息进行逻辑分类，然后通过 Partition 进一步做物理分片。三高问题都能和 Partition 关联。

![](https://mmbiz.qpic.cn/mmbiz_png/AaabKZjib2kYoV8r1cz8iakcS18uiaPaicUZ1hvzsKYS5BpvYMpkvBkNC0czv1HlyJIt2ANaibhvM8t6gatj1RSbKicQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

分区路由决定分区规则，如果设置合理，所有消息可以均匀分布到不同的 Partition 里，这样就实现了负载均衡。

有以下几种：
    
- 轮询Round-robin
- 随机Randomness(逊)
- 按消息键保序策略
Kafka 允许为每条消息定义消息键，简称为 Key。可以是一个有着明确业务含义的字符串，比如客户代码、部门编号或是业务 ID 等，一旦消息被定义了 Key，那么你就可以保证同一个 Key 的所有消息都进入到相同的分区里面，由于每个分区下的消息处理都是有顺序的，故这个策略被称为按消息键保序策略

### 这样做的好处
- 多个 Partition 会均匀地分布在集群中的每台机器上，从而很好地解决了**存储的扩展性**问题
- 多个消费者时可进行**消息并行处理**

### 分区规则指定 
1. 如果producer指定了要发送的目标分区，消息自然是去到那个分区；  
2. 否则就按照producer端参数partitioner.class指定的分区策略来定；    
3. 如果你没有指定过partitioner.class，那么默认的规则是：看消息是否有key，如果有则计算key的murmur2哈希值%topic分区数；如果没有key，按照**轮询**的方式确定分区。

## 分段存储
每个 Partition 又被分成了多个 Segment，Segment 从物理上可以理解成一个**数据文件 + 索引文件**
 
>每个 Segment 对应4个文件：“.index” 索引文件, “.log” 数据文件,  “.snapshot” 快照文件,  “.timeindex” 时间索引文件。    
这些文件都位于同一文件夹下面，该文件夹的命名规则为：topic 名称-分区号(从 0 开始的)。   

当写满了一个日志段后，Kafka 会自动切分出一个新的日志段，并将老的日志段封存起来。Kafka 在后台还有定时任务会定期地检查老的日志段是否能够被删除，从而实现回收磁盘空间的目的。

### 分段存储的好处
partition将数据记录到.log文件中，为了避免文件过大影响查询效率，将文件分段处理

记录消息到.log文件中的同时，会记录消息offset和物理偏移地址的映射作为索引，提升查找性能；

这个索引并不是按消息的顺序依次记录的，而是每隔一定字节的数据记录一条索引，降低了索引文件的大小

kafka查找消息时，只需要根据文件名和 offset 进行**二分查找**，找到对应的日志分段后，查找.index文件找到物理偏移地址，然后查.log读取消息内容


## Replica 多副本机制 
>一旦某台机器宕机，上面的数据怎么保证不丢失？机器恢复之前怎么保证数据仍可访问？

Kafka 通过 Partition 的多副本机制实现了故障的自动转移（**高可用**），当 Kafka 集群中某个 broker 失效时仍然能保证服务可用。

每个分区的多个副本需要保证数据的一致性，kafka会选择一个副本作为leader副本，其他作为follower副本。  
**只有leader副本负责处理客户端的读写请求（“Read-your-writes）**，follower副本**异步地**从leader副本拉取数据。

>对比：RabbitMQ 一个 queue 的数据都是放在一个节点里的，镜像集群下，也是每个节点都放这个 queue 的完整数据。


# 副本同步机制 
[参考](https://www.cnblogs.com/huxi2b/p/7453543.html)

## ISR
每个分区都有一个 ISR(in-sync Replica) 列表，用于维护所有同步的、可用的副本。  
如果一个follower副本宕机或落后太多，则该follower副本节点将从ISR列表中移除。  

### Kafka 判断 Follower 是否与 Leader 同步的标准
参数 `replica.lag.time.max.ms `，含义是 Follower 副本能够落后 Leader 副本的最长时间间隔，当前默认值是 10 秒。  
也就是说，只要一个 Follower 副本落后 Leader 副本的时间不连续超过 10 秒，那么 Kafka 就认为该 Follower 副本与 Leader 是同步的。  
否则此 Follower 副本就会被认为是与 Leader 副本不同步的，因此不能再放入 ISR 中。此时，Kafka 会自动收缩 ISR 集合，将该副本“踢出”ISR（踢出去后副本还会做同步操作）。 
Kafka 把所有不在 ISR 中的存活副本都称为**非同步副本**。 

倘若该副本后面慢慢地追上了 Leader 的进度（Follower的HighWatermark追赶上Leader），那么它是能够重新被加回 ISR 的。这也表明，ISR 是一个动态调整的集合，而非静态不变的。

### ISR 是怎么维护着的

### Leader节点的选举过程
各个节点公平竞争抢占 Zookeeper 系统中创建 /controller临时节点，最先创建成功的节点会成为控制器，并拥有选举主题分区Leader节点的功能。


### Unclean 领导者选举
如果 ISR 为空了，就说明 Leader 副本也“挂掉”了，Kafka 需要重新选举一个新的 Leader。  
非同步副本落后 Leader 太多，如果此时选择这些副本作为新 Leader，就会出现数据的丢失（但是提升了高可用性），选举这种副本的过程称为 Unclean 领导者选举。  
>参数 `unclean.leader.election.enable` 控制是否允许 Unclean 领导者选举。

## High Watermark 和 Log End Offset
Follower 是先从 Leader 那去同步然后再写入磁盘的，所以它磁盘上面的数据一般会比 Leader 的那块少一些。  
**高水位hw** ：副本最新一条己提交消息的 offset（都有的）     
**日志末端位移leo** ：副本中下一条待写入消息的 offset  

![图](https://img2022.cnblogs.com/blog/1331583/202210/1331583-20221016122546090-1040396702.png)

Kafka 所有副本都有对应的高水位和 LEO 值。  
Kafka 使用 Leader 副本的高水位来定义所在分区的高水位。换句话说，分区的高水位就是其 Leader 副本的高水位。  
在 Leader 副本所在的 Broker 上，还保存了其他 Follower 副本的 LEO 值。这些 Follower 副本又称为远程副本（Remote Replica）。  


### 高水位的作用
- 用来标识分区下的哪些消息是可以被消费者消费的（HW 之前的消息数据对消费者是可见的, 属于 commited 状态,  HW 之后包括等于的消息数据对消费者是不可见的）。  
- 协助 Kafka 完成副本数据同步  

LEO一个重要作用就是用来更新HW:  
如果 Follower 和 Leader 的 LEO 数据同步了, 那么 HW 就可以更新了。 

### hw和leo的更新机制
- Follower 副本 leo : 从 Leader 副本拉取消息写入本地磁盘后，会更新 leo 。
- Leader 副本 leo : 接受到生产者发送的消息，写入本地磁盘后，会更新 leo 。
- Leader 副本上远程副本 leo : Follower 从 Leader 副本拉取消息时，会告诉 Leader 从哪开始拉取，这个位移会被更新到远程副本 leo 。
- Follower 副本 hw : Follower 更新完 leo 后，用 min(leo, **Leader 发来的 hw**)更新自己的 hw 。
- Leader 副本 hw : Leader 更新完 leo 或更新完远程副本 leo 后，用 min(leo, **所有与该Leader同步的远程副本的 leo**)更新自己的 hw 。  
>与 Leader 副本保持同步。判断的条件有两个。
 1. 该远程 Follower 副本在 ISR 中。  
 2. 该远程 Follower 副本 LEO 值落后于 Leader 副本 LEO 值的时间，不超过 Broker 端参数 replica.lag.time.max.ms 的值。如果使用默认值的话，就是不超过 10 秒。

依托于高水位，Kafka 既界定了消息的对外可见性，又实现了异步的副本同步机制。

## Leader Epoch
Leader 副本高水位更新和 Follower 副本高水位更新在时间上是存在错配的。这种错配是很多“数据丢失”或“数据不一致”问题的根源。  
引入 Leader Epoch 来规避因高水位更新错配导致的各种不一致问题。  

组成部分：  
1. Epoch。一个单调增加的版本号。每当副本领导权发生变更时，都会增加该版本号。小版本号的 Leader 被认为是过期 Leader，不能再行使 Leader 权力。
2. 起始位移（Start Offset）。Leader 副本在该 Epoch 值上写入的首条消息的位移。  

如有两个 Leader Epoch<0, 0> 和 <1, 120>，那么，第一个 Leader Epoch 表示版本号是 0，这个版本的 Leader 从位移 0 开始保存消息，一共保存了 120 条消息。之后，Leader 发生了变更，版本号增加到 1，新版本的起始位移是 120。

这样，每次有 Leader 变更时，新的 Leader 副本会查询这部分缓存，取出对应的 Leader Epoch 的起始位移，以避免数据丢失和不一致的情况。
