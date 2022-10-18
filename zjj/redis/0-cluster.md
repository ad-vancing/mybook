# Redis 的集群模式
https://blog.csdn.net/saisai_in_csdn/article/details/106484724

https://zhuanlan.zhihu.com/p/424759752

支持三种集群方案
## 主从复制模式
数据库分为两类，一类是主数据库（master），另一类是从数据库(slave）。  
主数据库可以进行读写操作，当写操作导致数据变化时会自动将数据同步给从数据库。而从数据库一般是只读的，并接受主数据库同步过来的数据。  
一主多从。读写分离。  

主机宕机，宕机前有部分数据未能及时同步到从机，切换IP后还会引入数据不一致的问题，降低了系统的可用性。 
主从切换需要人工干预。  

## Sentinel（哨兵）模式/多哨兵模式  
主从复制的自动版？一主，二从，三哨兵。    
哨兵是一独立的进程，作为进程，它会独立运行。其原理是哨兵通过发送命令，等待Redis服务器响应，从而监控运行的多个 Redis 实例。  
`redis-sentinel sentinel1.conf`

当哨兵监测到 master 宕机，会自动将 slave 切换成 master ，然后通过发布订阅模式通知其他的从服务器，修改配置文件，让它们切换主机。  

可以实现高可用，但主从切换的过程中会丢失数据，因为只有一个master，只能单点写，没有解决水平扩容的问题。  

### 原理
1)：每个Sentinel以每秒钟一次的频率向它所知的Master/Slave以及其他 Sentinel 实例发送一个 PING 命令

2)：如果一个实例（instance）距离最后一次有效回复 PING 命令的时间超过 down-after-milliseconds 选项所指定的值， 则这个实例会被 Sentinel 标记为主观下线。

3)：如果一个Master被标记为主观下线，则正在监视这个Master的所有 Sentinel 要以每秒一次的频率确认Master的确进入了主观下线状态。

4)：当有足够数量的 Sentinel（大于等于配置文件指定的值：quorum）在指定的时间范围内确认Master的确进入了主观下线状态， 则Master会被标记为客观下线 。

5)：在一般情况下， 每个 Sentinel 会以每 10 秒一次的频率向它已知的所有Master，Slave发送 INFO 命令

6)：当Master被 Sentinel 标记为客观下线时，Sentinel 向下线的 Master 的所有 Slave 发送 INFO 命令的频率会从 10 秒一次改为每秒一次 ，若没有足够数量的 Sentinel 同意 Master 已经下线， Master 的客观下线状态就会被移除。

8)：若 Master 重新向 Sentinel 的 PING 命令返回有效回复， Master 的主观下线状态就会被移除。

主观下线：Subjectively Down，简称 SDOWN，指的是当前 Sentinel 实例对某个redis服务器做出的下线判断。

客观下线：Objectively Down， 简称 ODOWN，指的是多个 Sentinel 实例在对Master Server做出 SDOWN 判断，并且通过 SENTINEL之间交流后得出Master下线的判断。然后开启failover

### 谁来完成故障转移？
三个sentinel节点必须要通过某种机制达成一致，在Redis中采用了**Raft算法**来实现这个功能。  
选出Sentinel Leader之后，由Sentinel Leader向某个节点发送slaveof no one命令，让它成为独立节点。  
然后向其他节点发送replicaof x.x.x.x xxxx（本机服务），让它们成为这个节点的子节点，故障转移完成。

### Redis 的选举流程
有四个因素影响。

断开连接时长，如果与哨兵连接断开的比较久，超过了某个阈值，就直接失去了选举权
优先级排序，如果拥有选举权，那就看谁的优先级高，这个在配置文件里可以设置（replica-priority 100），数值越小优先级越高
复制数量，如果优先级相同，就看谁从master中复制的数据最多（复制偏移量最大）
进程id，如果复制数量也相同，就选择进程id最小的那个  


### 脑裂
某个master所在机器突然脱离了正常的网络，跟其他slave机器不能连接，但是实际上master还运行着，此时哨兵可能就会认为master宕机了，然后开启选举，将其他slave切换成了master，这个时候，集群里就会有两个master，也就是所谓的脑裂

## Cluster 模式
3.0版本开始正式提供。多主多从（多个主从复制的结构组合起来， 在这个节点组中只有master节点对用户提供些服务，读服务可以由master或者slave提供。当master出现故障时，slave会自动选举成为master顶替主节点继续提供服务），高并发。   
实现了 Redis 的分布式存储，也就是说每台 Redis 节点上存储不同的内容。 
![](https://img-blog.csdnimg.cn/dc91a19c03d14267ab9203fa337f25da.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAc3VuX2xt,size_20,color_FFFFFF,t_70,g_se,x_16)

![](https://pic3.zhimg.com/80/v2-8a70cdc990cac13618a3fae438fe0b9a_1440w.jpg)

每个一节点组对应数据sharding的一个分片。

### Gossip protocol 也叫 Epidemic Protocol （流行病协议）
在节点数量有限的网络中，每个节点都会“随机”（不是真正随机，而是根据规则选择通信节点）与部分节点通信，经过一番杂乱无章的通信后，每个节点的状态在一定时间内会达成一致。 

### 哈希槽hash slot
集群的每个节点负责一部分hash槽，每个 key 通过 CRC16 校验后对 16384 取模来决定放置到哪个槽。  
在redis集群中提供了下面的命令来计算当前key应该属于哪个slot
`redis> cluster keyslot key1`

#### Redis 集群要增加分片，槽的迁移怎么保证无损
缓存怎么做扩容
- 如果Redis被当做缓存使用，使用`一致性哈希实现动态扩容缩容`。
>一致性hash算法
一致性哈希算法是为了解决桶数量变化后，各个键值对应的桶都发生变化，造成缓存雪崩。

- 如果Redis被当做一个持久化存储使用，必须使用`固定的keys-to-nodes映射关系`，节点的数量一旦确定不能变化。否则的话(即Redis节点需要动态变化的情况），必须使用可以在运行时进行数据再平衡的一套系统，而当前只有Redis集群可以做到这样。


# Redis 怎么保证高可用
https://juejin.cn/post/6844903981148274701













# redis 如何做内存优化
尽可能使用散列表（hashes），散列表（是说散列表里面存储的数少）使用的内存非常小，所以你应该尽可能的将你的数据模型抽象到一个散列表里面。
比如你的web系统中有一个用户对象，不要为这个用户的名称，姓氏，邮箱，密码设置单独的key,而是应该把这个用户的所有信息存储到一张散列表里面。

>有哪些办法可以降低Redis的内存使用情况呢？
答：如果你使用的是32位的Redis实例，可以好好利用Hash,list,sorted set,set等集合类型数据，因为通常情况下很多小的Key-Value可以用更紧凑的方式存放到一起。




# 使用缓存时，先操作数据库还是先操作缓存

# 为什么是让缓存失效，而不是更新缓存



# 更新缓存的几种设计模式

>>如果你是Redis中高级用户，还有HyperLogLog、Geo、Pub/Sub可供使用。
如果你说还玩过Redis Module，像BloomFilter，RedisSearch，Redis-ML，面试官得眼睛就开始发亮了？

>Redis 到底是怎么实现“附近的人”
使用方式
GEOADD key longitude latitude member [longitude latitude member ...]
将给定的位置对象（纬度、经度、名字）添加到指定的key。其中，key为集合名称，member为该经纬度所对应的对象。在实际运用中，当所需存储的对象数量过多时，可通过设置多key(如一个省一个key)的方式对对象集合变相做sharding，避免单集合数量过多。
成功插入后的返回值：
(integer) N
其中N为成功插入的个数。






无论是哪种类型，Redis都不会直接存储，而是通过redisObject对象进行存储。


回收进程如何工作的？

一个客户端运行了新的命令，添加了新的数据。

Redi检查内存使用情况，如果大于maxmemory的限制, 则根据设定好的策略进行回收。

# remote dictionary server远程字典服务器  
C语言开发的  
TCP协议读写  
数据都存储在内存中，可达到10万个键值读写每秒。  
支持持久化。    
还可以限定数据占用的最大内存空间，数据量达到空间限制后会按一定的规则自动淘汰不需要的键。  
[Redis 服务器是一个事件驱动程序](https://www.javazhiyin.com/62931.html)
[Redis教程](https://www.redis.net.cn/tutorial/3524.html)

# redis通讯协议
RESP 是redis客户端和服务端之前使用的一种通讯协议；RESP 的特点：实现简单、快速解析、可读性好

## 适用场景
1. 会话缓存（Session Cache）/Session共享(单点登录) 
用Redis缓存会话比其他存储（如Memcached）的优势在于：Redis提供持久化。当维护一个不是严格要求一致性的缓存时，如果用户的购物车信息全部丢失，大部分人都会不高兴的，现在，他们还会这样吗？ 幸运的是，随着 Redis 这些年的改进，很容易找到怎么恰当的使用Redis来缓存会话的文档。甚至广为人知的商业平台Magento也提供Redis的插件。

2. 全页缓存（FPC）
除基本的会话token之外，Redis还提供很简便的FPC平台。回到一致性问题，即使重启了Redis实例，因为有磁盘的持久化，用户也不会看到页面加载速度的下降，这是一个极大改进，类似PHP本地FPC。 再次以Magento为例，Magento提供一个插件来使用Redis作为全页缓存后端。 此外，对WordPress的用户来说，Pantheon有一个非常好的插件 wp-redis，这个插件能帮助你以最快速度加载你曾浏览过的页面。

3. 队列 
可以利用列表类型键实现队列，并支持阻塞读取。
Reids在内存存储引擎领域的一大优点是提供 list 和 set 操作，这使得Redis能作为一个很好的消息队列平台来使用。Redis作为队列使用的操作，就类似于本地程序语言（如Python）对 list 的 push/pop 操作。 如果你快速的在Google中搜索“Redis queues”，你马上就能找到大量的开源项目，这些项目的目的就是利用Redis创建非常好的后端工具，以满足各种队列需求。例如，Celery有一个后台就是使用Redis作为broker，你可以从这里去查看。

4. 排行榜/计数器 
Redis在内存中对数字进行递增或递减的操作实现的非常好。集合（Set）和有序集合（Sorted Set）也使得我们在执行这些操作的时候变的非常简单，Redis只是正好提供了这两种数据结构。所以，我们要从排序集合中获取到排名最靠前的10个用户–我们称之为“user_scores”，我们只需要像下面一样执行即可： 当然，这是假定你是根据你用户的分数做递增的排序。如果你想返回用户及用户的分数，你需要这样执行： ZRANGE user_scores 0 10 WITHSCORES Agora Games就是一个很好的例子，用Ruby实现的，它的排行榜就是使用Redis来存储数据的，你可以在这里看到。

5. 发布/订阅 
最后（但肯定不是最不重要的）是Redis的发布/订阅功能。发布/订阅的使用场景确实非常多。我已看见人们在社交网络连接中使用，还可作为基于发布/订阅的脚本触发器。
用redis实现的聊天室就是用Redis的发布/订阅功能来建立的。

Redis还提供的高级工具
像慢查询分析、性能测试、Pipeline、事务、Lua自定义命令、Bitmaps、HyperLogLog、发布/订阅、Geo等个性化功能。







## 数据库
0-15一个16个库，默认使用第0号库。  
redis不支持自定义数据库名，也不支持为每个库设置不同的密码。  
数据库之间也不是完全隔离，`FLUSHALL`命令可以清空一个redis实例中所有库的数据。  
所以这些数据库更像是一种命名空间，不适合存储不同应用程序的数据，可以存储不同环境如测试、生产环境的数据。  

# 单机服务 
轻量级，一个空redis实例内存只有1MB左右。  

第一个小数点后的数字是偶数的版本是稳定版  
redis-benchmark 是redis性能测试工具  
redis-check-aof 是AOF文件修复工具  
redis-check-dump 是RDB文件检查工具  

生产环境推荐使用脚本启动redis，使得redis能随系统自动运行。  
将redis源代码目录utils里的redis_init_script脚本，拷贝到/etc/init.d目录中，重命名文件为redis_6379。  
新建/etc/redis目录存放配置文件（6379.conf），新建/var/redis/6379文件夹存放redis持久化文件。  

shutdown停止服务时，redis收到SHUTDOWN命令后会先断开所有客户端连接，然后根据配置执行持久化，最后完成退出。  
使用`kill`也可以正常停止redis服务。  

# 集群服务
[Redis 有哪些架构模式？讲讲各自的特点](https://mp.weixin.qq.com/s?__biz=MzI4Njc5NjM1NQ==&mid=2247487772&idx=2&sn=113b0e3b245c1d0e9d0213aea55e1c88&chksm=ebd62e30dca1a726de5ec533a85e5c6cc062e292ae7151c6efe8a5c72ec7aa28cc81412eecfd&scene=21#wechat_redirect)
[Redis单例、主从模式、sentinel以及集群的配置方式及优缺点对比](https://mp.weixin.qq.com/s?__biz=MzI4Njc5NjM1NQ==&mid=2247487959&idx=1&sn=2dbaf85f586da26f6f218a21ea01d0de&chksm=ebd62efbdca1a7ed051e7a2b87729bcf3731159dda729f7104af225c63e4e2bec8f18764b223&scene=21#wechat_redirect)
## 一主N从模式
![一主N从配置文件的方式实现主从库的分离](https://blog.csdn.net/cuipeng0916/article/details/53704629)
`通过使用 slaveof host port 命令来让一个服务器成为另一个服务器的从服务器`。
只能在主节点写数据。
redis主库挂了，并不会影响redis从库的运行，在从库中还是可以拿到数据的，但是看到master_line_status为down。
如果redis主库的服务有重新启动，redis从库会再次连接上主库，从库的master_line_status的连接状态都是up。

`slaveof no one`：在redis主服务挂了之后，可以再从redis从库服务中挑选出一个比较优秀的来接替主库的位置。

##  Sentinal哨兵模式
是一个分布式系统中监控 redis 主从服务，高可用，在master宕机时会自动将slave提升为master，继续提供服务。
在复制的基础上，哨兵实现了自动化的故障恢复。

三个特性：
监控（Monitoring）：Sentinel 会不断地检查你的主服务器和从服务器是否运作正常。
提醒（Notification）：当被监控的某个 Redis 服务器出现问题时， Sentinel 可以通过 API 向管理员或者其他应用程序发送通知。
自动故障迁移（Automatic failover）：当一个主服务器不能正常工作时， Sentinel 会开始一次自动故障迁移操作。

![哨兵模式配置，新建sentinel.conf文件](https://blog.csdn.net/cuipeng0916/article/details/53726092)
如果原来的主节点挂了，又回来了了，会变成从库。

缺陷：没有解决 master 写的压力，写操作无法负载均衡；存储能力受到单机的限制。
由于所有的写操作都是先在Master上操作，然后同步更新到Slave上，所以从Master同步到Slave机器有一定的延迟，当系统很繁忙的时候，延迟问题会更加严重，Slave机器数量的增加也会使这个问题更加严重。

>为了避免Master DB的单点故障，集群一般都会采用两台Master DB做双机热备，所以整个集群的读和写的可用性都非常高。
读写分离架构的缺陷在于，不管是Master还是Slave，每个节点都必须保存完整的数据，如果在数据量很大的情况下，集群的扩展能力还是受限于单个节点的存储能力，而且对于Write-intensive类型的应用，读写分离架构并不适合。

## 3.0版本以后的redis自带集群Redis-Cluster（直连型）
[redis集群(redis-cluster)的搭建](https://juejin.im/post/6844903592105623560)
[集群实战](https://www.iteye.com/blog/hot66hot-2050676)
是一个无中心的分布式Redis存储架构（不存在哪个节点影响性能瓶颈），少了 proxy 层。每个节点保存数据和整个集群状态,每个节点都和其他所有节点连接。解决了Redis高可用、可扩展等问题。

实现故障自动 failover，节点之间通过 gossip 协议交换状态信息，用投票机制完成 Slave到 Master 的角色提升。

可扩展性，可线性扩展到 1000 个节点，节点可动态添加或删除。

可以将每个节点看成都是独立的master，数据按照 slot 存储分布在多个节点，节点间数据共享，可动态调整数据分布或通过业务实现[数据分片](https://www.javazhiyin.com/62931.html)。
Redis 集群中内置了 16384个哈希槽，当需要在 Redis 集群中放置一个 key-value 时，redis 先对 key 使用 crc16 算法算出一个结果，然后把结果对 16384 求余数，这样每个 key 都会对应一个编号在 0-16383 之间的哈希槽，redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。
>Redis集群最大节点个数是多少
Redis集群预分好16384个桶(哈希槽)

![](https://user-gold-cdn.xitu.io/2018/4/17/162d1542a72fc4b7?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

缺点：
资源隔离性较差，容易出现相互影响的情况。
数据通过异步复制,不保证数据的强一致性。

### 补充：proxy 型集群
Twemproxy 是一个 Twitter 开源的一个 redis 和 memcache 快速/轻量级代理服务器；Twemproxy 是一个快速的单线程代理程序，支持 Memcached ASCII 协议和 redis 协议。
特点：
多种 hash 算法：MD5、CRC16、CRC32、CRC32a、hsieh、murmur、Jenkins
支持失败节点自动删除
后端 Sharding 分片逻辑对业务透明，业务方的读写方式和操作单个 Redis 一致
缺点：
增加了新的 proxy，需要维护其高可用。
failover 逻辑需要自己实现，其本身不能支持故障的自动转移可扩展性差，进行扩缩容都需要手动干预

### redis集群投票机制
redis集群中有多台redis服务器不可避免会有服务器挂掉。redis集群服务器之间通过互相的ping-pong判断是否节点可以连接上。如果有一半以上的节点去ping一个节点的时候没有回应，集群就认为这个节点宕机了。

>1. Redis-Cluster主从节点不要在同一个机器部署
   (1) 以我们的经验看redis实例本身基本不会挂掉，通常是机器出了问题（断电、机器故障）、甚至是机架、机柜出了问题，造成Redis挂掉。
   (2) 如果Redis-Cluster的主从都在一个机器上，那么如果这台机器挂了，主从全部挂掉，高可用就无法实现。（如果full converage=true，也就意味着整个集群挂掉）
   (3) 通常来讲一对主从所在机器：不跨机房、要跨机架、可以在一个机柜。
2. Redis-Cluster误判节点fail进行切换
  (1) Redis-Cluster是无中心的架构，判断节点失败是通过仲裁的方式来进行（gossip和raft），也就是大部分节点认为一个节点挂掉了，就会做fail判定。
  (2) 如果某个节点在执行比较重的操作（flushall, slaveof等等）（可能短时间redis客户端连接会阻塞(redis单线程)）或者由于网络原因，造成其他节点认为它挂掉了，会做fail判定。
  (3) Redis-Cluster提供了cluster-node-timeout这个参数（默认15秒），作为fail依据（如果超过15秒还是没反应，就认为是挂掉了）
   https://www.iteye.com/blog/carlosfu-2254573

### Redis集群各个结点的同步机制
Redis可以使用主从同步，从从同步。第一次同步时，主节点做一次bgsave，并同时将后续修改操作记录到内存buffer，待完成后将rdb文件全量同步到复制节点，复制节点接受完成后将rdb镜像加载到内存。加载完成后，再通知主节点将期间修改的操作记录同步到复制节点进行重放就完成了同步过程。

### Reids主从复制
复制是高可用Redis的基础，哨兵和集群都是在复制基础上实现高可用的。复制主要实现了数据的多机备份，以及对于读操作的负载均衡和简单的故障恢复。缺陷：故障恢复无法自动化；写操作无法负载均衡；存储能力受到单机的限制。

### 集群会有写操作丢失吗？为什么？
Redis并不能保证数据的强一致性，这意味这在实际中集群在特定的条件下可能会丢失写操作。








