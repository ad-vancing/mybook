https://blog.csdn.net/weixin_43570367/article/details/103809848

# 分布式集群下如何做到唯一序列号
使用Redis来生成ID。这主要依赖于Redis是单线程的，所以也可以用生成全局唯一的ID。可以用Redis的原子操作 INCR和INCRBY来实现。
Redis集群来获取更高的吞吐量。假如一个集群中有5台Redis。可以初始化每台Redis的值分别是1,2,3,4,5，然后步长都是5。

https://blog.csdn.net/riemann_/article/details/88858608#commentBox
# 分布式事务的原理，如何使用分布式事务


# 分布式锁如何设计
https://juejin.cn/post/7038596797446651940
https://blog.csdn.net/qq_40873718/article/details/105888915

1、分布式事务的控制。。

2、分布式session如何设计。

3、dubbo的组件有哪些，各有什么作用。

4、zookeeper的负载均衡算法有哪些。

5、dubbo是如何利用接口就可以通信的。

# CAP 理论
是分布式系统、特别是分布式存储领域中被讨论的最多的理论。  

其中C代表一致性 (Consistency)，A代表可用性 (Availability)，P代表分区容错性 (Partition tolerance)。

CAP理论告诉我们C、A、P三者不能同时满足，最多只能满足其中两个。

- 一致性 (Consistency)  
一个写操作返回成功，那么之后的读请求都必须读到这个新数据；如果返回失败，那么所有读操作都不能读到这个数据。所有节点访问同一份最新的数据。
  
- 可用性 (Availability)  
对数据更新具备高可用性，请求能够及时处理，不会一直等待，即使出现节点失效。
  
- 分区容错性 (Partition tolerance)  
能容忍网络分区，在网络断开的情况下，被分隔的节点仍能正常对外提供服务。  


# BASE 理论
[参考](https://www.jianshu.com/p/8624f50cd1f9)
BASE理论解决CAP理论提出了分布式系统的一致性和可用性不能兼得的问题。  
满足CAP理论，通过**牺牲强一致性，获得可用性**，一般应用在服务化系统的应用层或者大数据处理系统，通过**达到最终一致性**来尽量满足业务的绝大部分需求。

系统可能处于不一致的状态，但最终会变得一致。

系统在处理请求的过程中，可以存在短暂的不一致，在短暂的不一致窗口请求处理处在**临时状态**中，系统在做每步操作的时候，通过记录每一个临时状态，在系统出现故障的时候，可以从这些中间状态继续未完成的请求处理或者退回到原始状态，最后达到一致的状态。


# 2PC、3PC、
https://www.jianshu.com/p/30a18e4ef16e
https://blog.csdn.net/qq_39557240/article/details/106638353

# 分布式事务解决方案之TCC
https://cloud.tencent.com/developer/article/1547147
针对每个操作，都要注册一个与其对应的确认和补偿（撤销）操作，分为三个阶段：  
1. 预处理【try】：try是业务检查和资源预留的操作  
2. 确认【confirm】：confirm是业务确认操作  
3. 撤销【cancel】：cancel是实现一个与try相反的操作，即回滚  

## TCC 在 cancel 阶段如果出现失败怎么处理
https://cloud.tencent.com/developer/article/1844341

# 多台服务器如何保证数据的一致性
https://cloud.tencent.com/developer/article/2104858
