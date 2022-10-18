
# 分布式一致性算法 Consensus Algorithm
在分布式系统中让多个节点就某个决定达成共识。

Zookeeper 怎么保证数据的一致性
拜占庭将军问题   
一般的高可用架构都需要，因为主备切换、选举等过程需要集群中所有节点达成一致。  
由于硬件错误、网络拥塞或断开以及遭到恶意攻击，计算机和网络可能出现不可预料的行为，所以如何在这样的环境下达成一致，这就是所谓的数据一致性问题。  

## raft算法
先到先得，少数服从多数。  
redis 哨兵模式里用到。  
http://thesecretlivesofdata.com/raft/

## paxos
MySQL 5.7推出的用来取代传统的主从复制的MySQL Group Replication  
最早也是最正统的数据一致性算法，也是最复杂难懂的算法。  
https://www.cnblogs.com/linbingdong/p/6253479.html


## zab
是zookeeper中基于paxos算法上演变过来的一种一致性算法   

### 原理

## distro
阿里巴巴的私有协议，目前流行的Nacos服务管理框架就采用了Distro协议。Distro 协议被定位为 临时数据的一致性协议

# ZK集群原理

# Zookeeper 的使用场景

# Zookeeper 怎么实现分布式锁





# Zookeeper 遵循 CAP 中的哪些

# Zookeeper 和 Eureka 的区别

# Zookeeper 的 Leader 选举

# Observer 的作用

# Leader 发送了 commit 消息，但是所有的 follower 都没有收到这条消息，Leader 就挂了，后续会怎么处理


————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/99708892