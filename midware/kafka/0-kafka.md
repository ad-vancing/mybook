


https://kafka.apache.org/documentation/

[残漏补缺](https://mp.weixin.qq.com/s?__biz=MzIzNTIzNzYyNw%3D%3D&chksm=e8eb7b04df9cf2121a98984fae0207d422b9d643a2c3ff4d7c91cabfe2e8b4d530a62c376035&idx=1&lang=zh_CN&mid=2247484048&scene=21&sn=2de06942948b02842fd042e7783cbc61&token=267415244#wechat_redirect)

https://zhuanlan.zhihu.com/p/422389972

# 为什么使用 Kafka
3高、持久化、多副本备份、Scale out 横向扩展能力……… 

## 应用场景
应用监控、流处理、日志持久化处理

# Kafka 的各个组件
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305181714009.png)

- Broker：Broker是kafka的服务实例。  
每个服务器上有一个或多个kafka的实例。每个kafka集群内的broker都有一个不重复的编号，如broker-0、broker-1等……    
>第一个在ZooKeeper上成功创建 /controller 节点的 Broker 会被指定为控制器。控制器依赖 ZooKeeper行使其管理和协调的职责。

- Topic：可以理解为消息的分类，相当于rabbitMQ里的队列。  
生产者将消息发送到特定主题，消费者订阅主题或主题的某些分区进行消费。

- Partition：每个主题被分成一个或多个分区，分区数可配置、指定、修改。  
每个分区由一系列有序、不可变的消息组成，是一个**有序队列**。
partition的表现形式就是一个一个的文件夹，命名规则是“主题名—分区编号”，分区编号从0开始，编号最大值是分区的总数减1。  
>分区数越多吞吐量越高，是负载均衡的基础，提高kafka的吞吐量。 因为每一个分区对应消费者的一个处理线程，分区越多并发处理越好，但太多线程反而增加系统负担，需要通过测试确定合理分区数。

- Replication:每个分区有1至多个副本replica，它们分布在集群的不同代理上，以提高可用性。  
当主分区（Leader）故障的时候会选择一个副本（Follower）上位，成为Leader。  
>在kafka中默认副本的最大数量是10个，且副本的数量不能大于Broker的数量，follower和leader绝对是在不同的机器，同一机器对同一个分区也只可能存放一个副本（包括自己）。

- Message：是kafka通信的基本单位，由一个固定长度的消息头和一个可变长的消息体构成。   
每条消息被追加到相应的分区中，是顺序写磁盘，因此效率高。  
  >消息被消费后并不会立即被删除，kafka有两种删除已消费数据的策略：  
1）基于消息已存储的时长；  
2）基于分区的大小。  
支持Gzip、Snappy、LZ4这3种压缩方式。


- 偏移量offset  
副本被抽象成一个日志对象，消息被追加到`.log`文件尾部，同时每条消息在日志文件中的位置都会对应一个按序递增的偏移量。  
它是一个分区下有序的逻辑值，不表示消息在磁盘上的物理位置。  
消费者可以通过指定消息的起始偏移量来对消息进行消费。  
消费偏移量的管理交由消费者自己或组协调器来维护。    
从 0 开始。  

- 日志段logSegment  
它是kafka日志对象分片的最小单位。  
消息生产者发布的消息会被顺序写入对应的日志文件中。  
每个分区文件夹中，有多个日志段。  
一个日志段对应磁盘上一个具体日志文件`起始偏移量.log`和两个索引文件`.index`和`.timeindex`（分别表示消息偏移量索引文件和消息时间戳索引文件）。
因为只能追加写入，故避免了缓慢的随机 I/O 操作，改为性能较好的顺序 I/O 写操作，这也是实现 Kafka **高吞吐量**特性的一个重要手段。 

  消息被追加写到当前最新的日志段中，当写满了一个日志段后，Kafka 会自动切分出一个新的日志段，并将老的日志段封存起来。Kafka 在后台还有定时任务会定期地检查老的日志段是否能够被删除，从而实现回收磁盘空间的目的。 

- 消费者comsumer  
以拉取pull方式拉取数据。  
每个消费者有个唯一标识id，可通过配置项client.id指定，如果不指定，kafka会自动生成一个全局唯一的id。  
每个消费者有着自己的消费者位移。  

- 消费者组  
每个消费者都属于一个特定消费者组（用groupId代表消费者组）。  
如果不指定消费组，则该消费者属于`默认消费组test-consumer-group`。  
`同一个topic的一条消息只能被同一个消费者组下某一个消费者消费，但不同消费组的消费者可同时消费该消息`。  
同一个消费者组的消费者可以消费同一个topic的不同分区的数据，这也是为了**提高kafka的吞吐量（TPS）**！  
**消费组是kafka用来实现对一个主题消息进行广播和单播的手段，实现消息广播只需指定各消费者均属于不同的消费组；消息单播则只需让各消费者属于同一个消费组。**

- 重平衡：Rebalance。  
消费者组内某个消费者实例挂掉后，其他消费者实例自动重新分配订阅主题分区的过程。Rebalance 是 Kafka 消费者端实现**高可用**的重要手段。

- ISR/in-sync Replica  
即“保存同步的副本列表”，该列表中保存的是与leader副本保持消息同步的所有副本对应的代理节点id，包括 Leader 副本。  
如果一个follower副本宕机或落后太多，则该follower副本节点将从ISR列表中移除。

- zookeeper  
kafka利用zk保存相应元数据信息，如代理节点信息、kafka集群信息、消费者偏移量信息、主题信息、分区状态信息、分区副本信息等。  
通过zk的协调管理实现整个kafka集群的动态扩展、负载均衡。  
0.9版本前消费者消费消息的偏移量记录在zk中。  
2.x版本的元数据信息都不保存在zk上了。

# Kafka 怎么做到3高
[Kafka 三高架构](https://mp.weixin.qq.com/s?__biz=Mzg3MTcxMDgxNA==&mid=2247488842&idx=1&sn=8091e4f5f6dd1ab1d50bef48211e2d4e&source=41#wechat_redirect)

https://zhuanlan.zhihu.com/p/443164257      

## 高可用
1. 不同的 Broker 分散运行在不同的机器上，这样如果集群中某一台机器宕机，即使在它上面运行的所有 Broker 进程都挂掉了，其他机器上的 Broker 也依然能够对外提供服务。
2. 备份机制（Replication），每个 Partition 可以设置多个副本。此时我们对分区0,1,2分别设置3个副本（注:设置两个副本是比较合适的）。而且每个副本都是有"角色"之分的，它们会选取一个副本作为 Leader 副本，而其他的作为 Follower 副本，我们的 Producer 端在发送数据的时候，只能发送到Leader Partition里面 ，然后Follower Partition会去Leader那自行同步数据, Consumer 消费数据的时候，也只能从 Leader 副本那去消费数据的。

>Q:为什么 Kafka 不像 MySQL 那样允许追随者副本对外提供读服务？  
因为mysql一般部署在不同的机器上一台机器读写会遇到瓶颈，Kafka中的领导者副本一般均匀分布在不同的broker中，已经起到了负载的作用。

## 高性能
[做到单机每秒几十万的吞吐量，Kafka 的高性能设计可以说是全方位的，从 Prodcuer 、到 Broker、再到 Consumer，Kafka 在掏空心思地优化每一个细节，最终才做到了这样的极致性能。](https://mp.weixin.qq.com/s?__biz=MzU2MTM4NDAwMw==&mid=2247491507&idx=1&sn=f1bec356c94cd0101809dc11dcf27ba2&chksm=fc78c09fcb0f49898f6cc9b80499aeb871a80f95ab4fbe12c32567cab6a3521a6c33b61dd807&scene=178&cur_album_id=1763234202604388353#rd)

![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305181742821.png)

1. 顺序读写磁盘。Kafka 使用消息日志（Log）来保存数据，一个日志就是磁盘上一个只能追加写（Append-only）消息的物理文件。因为只能追加写入，故避免了缓慢的随机 I/O 操作，改为性能较好的顺序 I/O 写操作。
2. I/O 模型：epoll 系统调用则介于I/O 多路复用和信号驱动 I/O 之间的。Kafka 客户端底层使用了 Java 的 selector，selector 在 Linux 上的实现机制是 epoll，而在 Windows 平台上的实现机制是 select。因此在这一点上将 Kafka 部署在 Linux 上是有优势的，因为能够获得更高效的 I/O 性能。
3. 网络传输：零拷贝(Zero Copy)技术，就是当数据在磁盘和网络进行传输 时避免昂贵的内核态数据拷贝从而实现快速地数据传输。
4. lz4压缩

### 零拷贝技术使用哪个方法实现?
让操作系统的 os cache 中的数据直接发送到网卡后传出给下游的消费者，中间跳过了两次拷贝数据的步骤，从而减少拷贝的 CPU 开销, 减少用户态内核态的上下文切换次数,  从而优化数据传输的性能。  

>Kafka 主要使用到了 mmap  和 sendfile 的方式来实现零拷贝,  对应java里面的 MappedByteBuffer 和 FileChannel.transferIO。  
使用 java NIO 实现的 零拷贝,



# 场景设计
[Kafka生产级容量评估方案](https://mp.weixin.qq.com/s?__biz=Mzg3MTcxMDgxNA==&mid=2247488846&idx=1&sn=1d77a05c7e94abd8044502c433d9aeee&source=41#wechat_redirect)

# 消息传递的过程中数据重复或丢失的问题
## 消息传递语义
at most once：消息会丢，但不重复  
at least once ：消息不丢，但被多次重复处理  
exactly once：保证不丢失、且只会被精确的处理一次。  

默认 Kafka 提供「at least once」语义的消息传递（不丢数据），允许用户通过在处理消息之前保存 Offset的方式提供 「at most once」 语义（不重复数据）。

如果我们可以自己实现消费幂等，理想情况下这个系统的消息传递就是严格的「exactly once」, 也就是保证不丢失、且只会被精确的处理一次，但是这样是很难做到的。


## Producer 端发送消息给 Kafka Broker 端。
### 消息发送流程
1）首先我们要知道一点就是Producer 端是直接与 Broker 中的 Leader Partition 交互的，所以在 Producer 端初始化中就需要通过 Partitioner 分区器从 Kafka 集群中获取到相关 Topic 对应的 Leader Partition 的元数据。

2）待获取到 Leader Partition 的元数据后直接将消息发送过去。

3）Kafka Broker 对应的 Leader Partition 收到消息会先写入 Page Cache，定时刷盘进行持久化（顺序写入磁盘）。

4) Follower Partition 拉取 Leader Partition 的消息并保持同 Leader Partition 数据一致，待消息拉取完毕后需要给 Leader Partition 回复 ACK 确认消息。

5）待 Kafka Leader 与 Follower Partition 同步完数据并收到所有 ISR 中的 Replica 副本的 ACK 后，Leader Partition 会给 Producer 回复 ACK 确认消息。

Broker 成功“提交”消息且 Producer 接到 Broker 的应答才会认为该消息成功发送。

### 导致 Producer 端消息没有发送成功原因
网络原因：由于网络抖动导致数据根本就没发送到 Broker 端。

数据原因：消息体太大超出 Broker 承受范围而导致 Broker 拒收消息。

### 一些消息丢失避免机制
使用带回调通知函数的方法进行发送消息，即 Producer.send(msg, callback), 这样一旦发现发送失败， 就可以做针对性处理。  

acks参数，控制的是消息的持久化程度。这个参数实际上有三种设置，分别是：0、1 和 all。    
acks 默认配置为1，默认级别是 at least once 语义。 如果 Producer 没有收到消息 commit 的响应结果，它只能重新发送消息。    

重试次数 retries， Producer 端就会一直进行重试直到 Broker 端返回 ACK 标识。  

重试时间 retry.backoff.ms。消息发送超时后两次重试之间的间隔时间，避免无效的频繁重试，默认值为100ms, 推荐设置为300ms。

### 一些消息重复避免机制
- 启用**幂等传递**创建幂等性 Producer  
`props.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG， true)`。    
缺点：它只能保证单分区上的幂等性，即一个幂等性 Producer 能够保证某个主题的一个分区上不出现重复消息，它无法实现多个分区的幂等性。其次，它只能实现单会话上的幂等性，不能实现跨会话的幂等性。这里的会话，你可以理解为 Producer 进程的一次运行。当你重启了 Producer 进程之后，这种幂等性保证就丧失了。


- 启用**事务**支持创建事务型 Producer  
幂等性 Producer 只能保证单分区、单会话上的消息幂等性；而事务能够保证跨分区、跨会话间的幂等性。

设置事务型 Producer 需要满足两个要求即可：  
1）和幂等性 Producer 一样，开启 enable.idempotence = true。  
2）设置 Producer 端参数 transctional.id。最好为其设置一个有意义的名字。    
目前主要是在 read committed 隔离级别上做事情。  

Broker 为 Producer 分配了一个ID，并通过每条消息的序列号进行去重。    
也支持了类似事务语义来保证将消息发送到多个 Topic 分区中，保证所有消息要么都写入成功，要么都失败，这个主要用在 Topic 之间的 exactly once 语义。

它能保证多条消息原子性地写入到目标分区，也不惧进程的重启。

```
producer.initTransactions();
try {
            producer.beginTransaction();
            producer.send(record1);
            producer.send(record2);
            producer.commitTransaction();
} catch (KafkaException e) {
            producer.abortTransaction();
}
```

这段代码能够保证 Record1 和 Record2 被当作一个事务统一提交到 Kafka，要么它们全部提交成功，要么全部写入失败。实际上即使写入失败，Kafka 也会把它们写入到底层的日志中，也就是说 Consumer 还是会看到这些消息。  
因此在 Consumer 端，需要保证 Consumer 只能看到事务成功提交的消息。  
设置 isolation.level 参数的值即可。当前这个参数有两个取值：  
1) read_uncommitted：这是默认值，表明 Consumer 能够读取到 Kafka 写入的任何消息，不论事务型 Producer 提交事务还是终止事务，其写入的消息都可以读取。很显然，如果你用了事务型 Producer，那么对应的 Consumer 就不要使用这个值。  
2) read_committed：表明 Consumer 只会读取事务型 Producer 成功提交事务写入的消息。当然了，它也能看到非事务型 Producer 写入的所有消息。

比起幂等性 Producer，事务型 Producer 的性能要更差，在实际使用过程中，我们需要仔细评估引入事务的开销，切不可无脑地启用事务。

## Kafka Broker 将消息进行同步并持久化数据
Broker 端消息存储是通过异步批量刷盘的，那么这里就可能会丢数据的!  
通过「多 Partition （分区）多 Replica（副本）机制」已经可以最大限度的保证数据不丢失，如果数据已经写入 PageCache 中但是还没来得及刷写到磁盘，此时如果所在 Broker 突然宕机挂掉或者停电，极端情况还是会造成数据丢失。  

acks = 1：消息发送 Leader Parition 接收成功就表示发送成功，这时只要 Leader Partition 不 Crash 掉，就可以保证 Leader Partition 不丢数据，但是如果 Leader Partition 异常 Crash 掉了， Follower Partition 还未同步完数据且没有 ACK，这时就会丢数据。
   
acks = all：消息发送需要等待 ISR 中 Leader Partition 和 所有的 Follower Partition 都确认收到消息才算发送成功, 可靠性最高, 但也不能保证不丢数据,比如当 ISR 中只剩下 Leader Partition 了, 这样就变成 acks = 1 的情况了。

### 其他注意的
unclean.leader.election.enable  
该参数表示有哪些 Follower 可以有资格被选举为 Leader , 如果一个 Follower 的数据落后 Leader 太多，那么一旦它被选举为新的 Leader， 数据就会丢失，因此我们要将其设置为false，防止此类情况发生。  

min.insync.replicas  
表示消息至少要被写入成功到 ISR 多少个副本才算"已提交"，建议设置min.insync.replicas > 1,这样才可以提升消息持久性，保证数据不丢失。  
还需要确保一下replication.factor > min.insync.replicas, 如果相等，只要有一个副本异常 Crash 掉，整个分区就无法正常工作了，因此推荐设置成：replication.factor =min.insync.replicas +1, 最大限度保证系统可用性。  


## Consumer 端从Kafka Broker 将消息拉取并进行消费。
### 自动提交
`enable.auto.commit = true` ，Kafka 会保证在开始调用 poll 方法时，提交上次 poll 返回的所有消息，默认情况下，Consumer 每 5 秒自动提交一次位移。。  
从顺序上来说，poll 方法的逻辑是先提交上一批消息的位移，再处理下一批消息，不能绝对保证不丢消息。  
自动提交位移的一个问题在于，它可能会出现重复消费！why？ 

### 手动提交
设置参数`enable.auto.commit = false`。  
采用手动提交位移的方式调用`commitSync()`，因为它是阻塞的，会影响整个应用程序的 TPS。     
采用手动提交位移的方式调用`commitAsync()`，是一个异步操作并提供了回调函数（callback），缺点是提交失败不能后自动重试，因为可能早已经“过期”或不是最新值了。 

组合使用：  
```
 try {
            while (true) {
                        ConsumerRecords<String, String> records = 
                                    consumer.poll(Duration.ofSeconds(1));
                        process(records); // 处理消息
                        commitAysnc(); // 使用异步提交规避阻塞
            }
} catch (Exception e) {
            handle(e); // 处理异常
} finally {
            try {
                        consumer.commitSync(); // 最后一次提交使用同步阻塞式提交
	} finally {
	     consumer.close();
}
}
```

将一个大事务分割成若干个小事务分别提交:  
commitSync(Map<TopicPartition, OffsetAndMetadata>) 和 commitAsync(Map<TopicPartition, OffsetAndMetadata>)

另外注意手动提交的2种情况：  
1） Consumer 收到消息后先更新 Offset， 这时 Consumer 异常 crash 掉， 那么新的 Consumer 接管后再次重启消费，就会造成 at most once 语义。

2） Consumer 消费消息完成后, 再更新 Offset，如果这时 Consumer crash 掉，那么新的 Consumer 接管后重新用这个 Offset 拉取消息， 这时就会造成 at least once 语义。只能业务自己保证幂等性。



# 补充拓展

## Kafka 拦截器（了解）
Kafka 拦截器分为生产者拦截器 ProducerInterceptor 和消费者拦截器。生产者拦截器允许你在发送消息前以及消息提交成功后植入你的拦截器逻辑；而消费者拦截器支持在消费消息前以及提交位移后编写特定逻辑。值得一提的是，这两种拦截器都支持链的方式，即你可以将一组拦截器串连成一个大的拦截器，Kafka 会按照添加顺序依次执行拦截器逻辑。

## Apache Kafka 的所有通信都是基于 TCP 的
### Kafka 的 Producer 客户端是如何管理这些 TCP 连接的?
Java Producer 端管理 TCP 连接的方式是：  
- KafkaProducer 实例创建时启动 Sender 线程，从而创建与 bootstrap.servers 中所有 Broker 的 TCP 连接。
- KafkaProducer 实例首次更新元数据信息之后，还会再次创建与集群中所有 Broker 的 TCP 连接。
- 如果 Producer 端发送消息到某台 Broker 时发现没有与该 Broker 的 TCP 连接，那么也会立即创建连接。
- 如果设置 Producer 端 `connections.max.idle.ms` 参数大于 0，则步骤 1 中创建的 TCP 连接会被自动关闭；如果设置该参数 =-1，那么步骤 1 中创建的 TCP 连接将无法被关闭，从而成为“僵尸”连接。

>无论在bootstrap.servers中是否写全部broker 的地址接下来producer 还是会跟所有的broker 建立一次连接

# broker 内部
## Reactor 模式
是事件驱动架构的一种实现方式，特别适合应用于处理多个客户端并发向服务器端发送请求的场景。  
多个客户端会发送请求给到 Reactor，请求分发线程 Dispatcher（Acceptor 线程）会将不同的请求通过轮询的方式下发到多个工作线程（网络线程）处理。  
工作线程可以根据实际业务处理需要任意增减，从而动态调节系统负载能力。   
`num.network.threads`默认值是 3，表示每台 Broker 启动时会创建 3 个网络线程。

## 网络线程接收到请求后，是怎么处理
![](https://img2022.cnblogs.com/blog/1331583/202210/1331583-20221015221232168-416251772.png)
网络线程拿到请求后，它不是自己处理，而是将请求放入到一个共享请求队列中；  
有个 IO 线程池，负责从该队列中取出请求，执行真正的处理。  
  如果是 PRODUCE 生产请求，则将消息写入到底层的磁盘日志中；如果是 FETCH 请求，则从磁盘或页缓存中读取消息。  
  `num.io.threads`控制了这个线程池中的线程数。目前该参数默认值是 8，表示每台 Broker 启动后自动创建 8 个 IO 线程处理请求。  
当 IO 线程处理完请求后，会将生成的响应发送到网络线程池的响应队列中，然后由对应的网络线程负责将 Response 返还给客户端。

## Purgatory 的组件
是用来缓存延时请求（Delayed Request）的。  
所谓延时请求，就是那些一时未满足条件不能立刻处理的请求。比如设置了 acks=all 的 PRODUCE 请求  


# kafka 与 zooKeeper
## zk 对 kafka 的作用
- Kafka 重度依赖它实现各种各样的协调管理。  
比如侦测 Broker 存活性是zk的临时节点。每个 Broker 启动后，会在 /brokers/ids 下创建一个临时 znode。当 Broker 宕机或主动关闭后，该 Broker 与 ZooKeeper 的会话结束，这个 znode 会被自动删除。同理，ZooKeeper 的 Watch 机制将这一变更推送给控制器，这样控制器就能知道有 Broker 关闭或宕机了，从而进行“善后”。


- 元数据存储
老版本的 Consumer Group 把消费消息的位移保存在 ZooKeeper 中。好处就是减少了 Kafka Broker 端的状态保存开销。这样可以自由地扩缩容，实现超强的伸缩性。  
不过 ZooKeeper 这类元框架其实并不适合进行频繁的写更新，而 Consumer Group 的位移更新却是一个非常频繁的操作。这种大吞吐量的写操作会极大地拖慢 ZooKeeper 集群的性能。  
于是，在新版本的 Consumer Group 中，Kafka 社区重新设计了 Consumer Group 的位移管理方式，采用了将位移保存在 Kafka 内部主题——位移主题** __consumer_offsets**。


# 生产与消费的速率监控
- lag：分区里消息的最大 offset - 已消费的最大offset

- lead：已消费的最大offset - 分区里消息的最小 offset
 lead越小意味着consumer消费的消息越来越接近被删除的边缘，显然是不好的
 
 如果消费者慢到消费的数据被删除，会出现两个后果，1消费者从头消费一遍数据，2从最新消息位移开始消费；   
 取决于auto.offset.reset的值
