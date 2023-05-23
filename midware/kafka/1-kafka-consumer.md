
# Kafka Consumer Group 
每个 Consumer Group 有一个或者多个 Consumer。每个 Consumer Group 拥有一个公共且唯一的 Group ID。    
>Kafka 仅仅使用 Consumer Group 这一种机制，同时实现了传统消息引擎系统的两大模型：如果所有实例都属于同一个 Group，那么它实现的就是消息队列模型；如果所有实例分别属于不同的 Group，那么它实现的就是发布 / 订阅模型。
  
Consumer Group 在消费 Topic 的时候，Topic 的每个 Partition 只能分配给组内的某个 Consumer，只要被任何 Consumer 消费一次, 那么这条数据就可以认为被当前 Consumer Group 消费成功。

>在使用过程中不推荐设置大于总分区数的 Consumer 实例，这样只会浪费资源。

# Kafka 怎么保证消息的顺序消费
1. 所有的消息都只在这一个分区内读写，因此保证了全局的顺序性。这样做虽然实现了因果关系的顺序性，但也丧失了 Kafka 多分区带来的高吞吐量和负载均衡的优势。
2. 设定专门的分区策略，把标志位数据提取出来统一放到 Key 中，保证同一标志位的所有消息都发送到同一分区，这样既可以保证分区内的消息顺序，也可以享受到多分区带来的性能红利。

# Kafka 怎么避免重复消费


# Consumer之消费者组重分配机制 Consumer Rebalance
对于 Consumer Group 来说，可能随时都会有 Consumer 加入或退出，那么 Consumer 列表的变化必定会引起 Partition 的重新分配（每个 Consumer 实例都能够得到较为平均的分区数）。

Rebalance 本质上是一种协议，规定了一个 Consumer Group 下的所有 Consumer 如何达成一致，来分配订阅 Topic 的每个分区。

[参考](https://mp.weixin.qq.com/s?__biz=Mzg3MTcxMDgxNA==&mid=2247488851&idx=1&sn=987824e5ba607e2e33ae0c64adb77d84&source=41#wechat_redirect)
## Consumer Group 何时进行 Rebalance 
- 组成员数发生变更。比如有新的 Consumer 实例加入组或者离开组，抑或是有 Consumer 实例崩溃被“踢出”组，网络断了，心跳中断等。
- 订阅主题数发生变更。Consumer Group 可以使用正则表达式的方式订阅主题，比如 `consumer.subscribe(Pattern.compile(“t.*c”))` 就表明该 Group 订阅所有以字母 t 开头、字母 c 结尾的主题。在 Consumer Group 的运行过程中，你新创建了一个满足这样条件的主题，那么该 Group 就会发生 Rebalance。
- 订阅主题的分区数发生变更。Kafka 当前只能允许增加一个主题的分区数。当分区数增加时，就会触发订阅该主题的所有 Group 开启 Rebalance。

## Rebalance 的缺点
在 Rebalance 过程中，所有 Consumer 实例都会停止消费，等待 Rebalance 完成，对 Consumer 的 TPS 影响很大。

效率不高，更高效的做法是尽量减少分配方案的变动。如果可能的话，最好还是让实例 A 继续消费分区 1、2、3，而不是被重新分配其他的分区。这样的话，实例 A 连接这些分区所在 Broker 的 TCP 连接就可以继续用，不用重新创建连接其他 Broker 的 Socket 资源。

慢，比如有几百个 Consumer 实例时。

最好还是避免 Rebalance！！！

## Coordinator
它专门为 Consumer Group 服务，负责为 Group 执行 Rebalance 以及提供位移管理和组成员管理等。

## 哪些 Rebalance 是不必要需要避免的？怎么避免
- 未能及时发送心跳，导致 Consumer 被“踢出”Group 而引发的。  
设置`session.timeout.ms= 6s` 和 `heartbeat.interval.ms= 2s`的值。  
保证 Consumer 实例在被判定为“dead”之前，能够发送至少 3 轮的心跳请求，即 session.timeout.ms >= 3 * heartbeat.interval.ms。

- Consumer 消费时间过长导致  
max.poll.interval.ms参数值最好设置得大一点，比你的下游最大处理时间稍长一点。

- Consumer 端的 GC 表现  
比如是否出现了频繁的 Full GC 导致的长时间停顿，从而引发了 Rebalance。   
GC 设置不合理导致程序频发 Full GC 而引发的非预期 Rebalance 也有很多。

### 相关参数解释
- session.timeout.ms
当 Consumer Group 完成 Rebalance 之后，每个 Consumer 实例都会定期地向 Coordinator 发送心跳请求，表明它还存活着。如果某个 Consumer 实例不能及时地发送这些心跳请求，Coordinator 就会认为该 Consumer 已经“死”了，从而将其从 Group 中移除，然后开启新一轮 Rebalance。  
Consumer 端参数`session.timeout.ms`，就是被用来表征此事的。该参数的默认值是 10 秒，即如果 Coordinator 在 10 秒之内没有收到 Group 下某 Consumer 实例的心跳，它就会认为这个 Consumer 实例已经挂了。可以这么说，session.timout.ms 决定了 Consumer 存活性的时间间隔。

- heartbeat.interval.ms
Consumer 还有一个允许你控制发送心跳请求频率的参数，`heartbeat.interval.ms`。  
这个值设置得越小，Consumer 实例发送心跳请求的频率就越高。频繁地发送心跳请求会额外消耗带宽资源，但好处是能够更加快速地知晓当前是否开启 Rebalance，因为，目前 Coordinator 通知各个 Consumer 实例开启 Rebalance 的方法，就是将 REBALANCE_NEEDED 标志封装进心跳请求的响应体中。

- max.poll.interval.ms
Consumer 端还有一个参数，用于控制 Consumer 实际消费能力对 Rebalance 的影响，即 `max.poll.interval.ms` 参数。它限定了 Consumer 端应用程序两次调用 poll 方法的最大时间间隔。它的默认值是 5 分钟，表示你的 Consumer 程序如果在 5 分钟之内无法消费完 poll 方法返回的消息，那么 Consumer 会主动发起“离开组”的请求，Coordinator 也会开启新一轮 Rebalance。

## 重平衡过程是如何通知到其他消费者实例的
Kafka Java 消费者有一个单独的心跳线程来专门定期地执行心跳请求发送请求（Heartbeat Request）到 Broker 端的协调者，以表明它还存活着。  
重平衡的通知机制正是通过**心跳线程**来完成的。当协调者决定开启新一轮重平衡后，它会将“REBALANCE_IN_PROGRESS”封装进心跳请求的响应中，发还给消费者实例。当消费者实例发现心跳响应中包含了“REBALANCE_IN_PROGRESS”，就能立马知道重平衡又开始了。

## 重平衡时消费者组的状态流转
Kafka 为消费者组定义了 5 种状态，它们分别是：Empty、Dead、PreparingRebalance、CompletingRebalance 和 Stable。  
一个消费者组最开始是 Empty 状态，当重平衡过程开启后，它会被置于 PreparingRebalance 状态等待成员加入，之后变更到 CompletingRebalance 状态等待分配方案，最后流转到 Stable 状态完成重平衡。  

## 消费者端重平衡流程
在消费者端，重平衡分为两个步骤：分别是加入组和等待领导者消费者（Leader Consumer）分配方案。这两个步骤分别对应两类特定的请求：JoinGroup 请求和 SyncGroup 请求。  

当组内成员加入组时，它会向协调者发送 JoinGroup 请求。通常情况下，第一个发送 JoinGroup 请求的成员自动成为领导者。   
协调者会把消费者组订阅信息封装进 JoinGroup 请求的响应体中，然后发给领导者，由领导者统一做出分配方案后，进入到下一步：发送 SyncGroup 请求。  

领导者向协调者发送 SyncGroup 请求，将刚刚做出的分配方案发给协调者。值得注意的是，其他成员也会向协调者发送 SyncGroup 请求，只不过请求体中并没有实际的内容。这一步的主要目的是让协调者接收分配方案，然后统一以 SyncGroup 响应的方式分发给所有成员，这样组内所有成员就都知道自己该消费哪些分区了。

## Broker 端重平衡场景剖析
### 场景一：新成员入组是指组处于 Stable 状态后，有新成员加入。
### 场景二：组成员主动离组。
### 场景三：组成员崩溃离组。
协调者通常需要等待一段时间才能感知到，这段时间一般是由消费者端参数 session.timeout.ms 控制的
### 场景四：重平衡时协调者对组内成员提交位移的处理。


