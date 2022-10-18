# hive 服务优化
1. 数据倾斜角度
2. 对小文件进行合并  
   hive参数：
   ```
   设置map输入合并小文件的相关参数：
   
   //每个Map最大输入大小(这个值决定了合并后文件的数量)
   set mapred.max.split.size=256000000;  
   //一个节点上split的至少的大小(这个值决定了多个DataNode上的文件是否需要合并)
   set mapred.min.split.size.per.node=100000000;
   //一个交换机下split的至少的大小(这个值决定了多个交换机上的文件是否需要合并)  
   set mapred.min.split.size.per.rack=100000000;
   //执行Map前进行小文件合并
   set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat; 
   
   设置map输出和reduce输出进行合并的相关参数：
   
   //设置map端输出进行合并，默认为true
   set hive.merge.mapfiles = true
   //设置reduce端输出进行合并，默认为false
   set hive.merge.mapredfiles = true
   //设置合并文件的大小
   set hive.merge.size.per.task = 256*1000*1000
   //当输出文件的平均大小小于该值时，启动一个独立的MapReduce任务进行文件merge。
   set hive.merge.smallfiles.avgsize=16000000
   ————————————————
   版权声明：本文为CSDN博主「下山化缘的DJ」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
   原文链接：https://blog.csdn.net/qq_39150361/article/details/117911513
   ```
3. map、reduce任务数量  
   如果reduce太少：如果数据量很大，会导致这个reduce异常的慢，从而导致这个任务不能结束，也有可能会OOM 2、如果reduce太多： 产生的小文件太多，合并起来代价太高，namenode的内存占用也会增大。

   ```
   //这个参数控制一个job会有多少个reducer来处理，依据的是输入文件的总大小。默认1GB。
   hive.exec.reducers.bytes.per.reducer
   
   //这个参数控制最大的reducer的数量， 如果 input / bytes per reduce > max 则会启动这个参数所指定的reduce个数。这个并不会影响mapre.reduce.tasks参数的设置。默认的max是999。
   hive.exec.reducers.max 
   
   //这个参数如果指定了，hive就不会用它的estimation函数来自动计算reduce的个数，而是用这个参数来启动reducer。默认是-1。
   mapred.reduce.tasks
   ```


# hive sql 优化
把hive sql当做mapreduce程序来读，理解hadoop的核心能力，是hive优化的根本。

1. 小文件角度  
   hive中对表执行insert into 操作，每次插入数据都在表目录下形成一个小文件,这个小文件就是MR任务reduce端的输出文件。
   解决：insert overwrite into table t_new as select * from t_old;
   
2. 注意效率低下的函数、关键字使用（避免倾斜）
   [COUNT(DISTINCT id)的优化](https://blog.csdn.net/BIT_666/article/details/124798817)   
   GROUP BY操作
   
3. 数据的时候，可以只读取查询中所需要用到的列、减少不必要的分区 

# hive数据倾斜怎么解决
https://zhuanlan.zhihu.com/p/425104815  
https://www.studytime.xin/article/hive-knowledge-data-skew.html

数据倾斜后直观表现是执行一个非常简单的SQL语句，任务的进度条长时间卡在99%，不确定还需多久才能结束，这种现象称之为数据倾斜。也可能导致Out Of Memory。  

在整个计算过程中，大量相同的key被分配到了同一个任务上，造成“一个人累死、其他人闲死”的状况，这违背了分布式计算的初衷，使得整体的执行效率十分低下。

Map端的数据倾斜一般是由于 HDFS 数据存储不均匀造成的（一般存储都是均匀分块存储，每个文件大小基本固定，所以发生数据倾斜概率比较小）。    
Reduce阶段（或者说是Shuffle阶段）的数据倾斜几乎都是因为数据研发工程师没有考虑到某种key值数据量偏多的情况而导致的。

## 产生的原因
- 数据某字段值分布不均匀导致count(distinct)、count(distinct)时产生倾斜问题。
- 业务数据本身的特性
- 建表时考虑不周
- 某些SQL语句本身就有数据倾斜

## 解决方案
### 开启负载均衡
`set hive.groupby.skewindata=true` （默认为false）  
会生成两个额外的 MR Job：  
在第一个 MapReduce 中，map 的输出结果集合首先会随机分配到 reduce 中，然后每个 Reduce 做局部聚合操作并输出结果，这样处理的原因是相同的Group By Key有可能被分发到不同的 Reduce Job中，从而达到负载均衡的目的。  
第二个 MapReduce 再根据预处理的数据结果按照 Group By Key 分布到 Reduce 中（这个过程可以保证相同的 Group By Key 被分布到同一个 Reduce 中），最后完成聚合操作。

![](https://ask.qcloudimg.com/http-save/yehe-9951765/6afa5f545cd740d2e28b0af93797887b.png?imageView2/2/w/1620)

### map端聚合  
`set hive.map.aggr=true；`（默认为ture）用于设定是否在 map 端进行聚合  
`set hive.groupby.mapaggr.checkinterval=100000`设定 map 端进行聚合操作的条目数

### join连接时的不同情况
两表进行join时，如果表连接的key存在倾斜，那么在 Shuffle 阶段必然会引起数据倾斜。

- 小表join大表，某个key过大
解决方式：mapjoin(默认启动该优化)，join 操作在 Map 阶段完成，不再需要Reduce，前提条件是需要的数据在 Map 的过程中可以访问到。
- 表中作为关联条件的字段值为0或空值的较多
所有的null值都会被分配到一个reduce中。  
解决方式：因为null值参与shuffle时的hash结果是一样的，那么我们可以给null值随机赋值，这样它们的hash结果就不一样，就会进到不同的reduce中。
- 表中作为关联条件的字段重复值过多
- 不同数据类型关联产生数据倾斜  
如果key字段既有string类型也有int类型，默认的hash就都会按int类型来分配。  
解决方式：直接把int类型都转为string就好了，这样key字段都为string，hash时就按照string类型分配