#Shuffle
Shuffle 过程本质上都是将 Map 端获得的数据使用分区器进行划分，并将数据发送给对应的 Reducer 的过程。
## map 端的Shuffle
1. input, 每个map对应一个jvm实例，处理1个split数据分片，产生一个map输出文件;
2. patition, 每个map task都有一个内存缓冲区，存储着map的输出结果;
3. spill, 当缓冲区快满的时候需要将缓冲区的数据以临时文件的方式存放到磁盘;
4. merge, 当整个map task结束后再对磁盘中这个map task产生的所有临时文件做合并，生成最终的正式输出文件，然后等待reduce task来拉数据。


## reduce 端的Shuffle
通过Partitioner接口，根据key或value及reduce的数量来决定当前map的输出数据最终应该交由哪个reduce task处理。Reduce去前面的map的输出结果中抓取属于自己的数据。
1. Copy拉取数据。
2. Merge合并拉取来的小文件（从不同地方拉取过来的数据不断地做merge，也最终形成一个文件作为reduce task的输入文件）
3. Reducer计算
4. Output输出计算结果

![](http://www.2cto.com/uploadfile/Collfiles/20171206/20171206093241328.png)

# spark shuffle
## 触发shuffle操作的算子
distinct、groupByKey、reduceByKey、aggregateByKey、join、cogroup、repartition等。

宽依赖之间会划分stage，而Stage之间就是Shuffle。

在Spark的中，负责shuffle过程的执行、计算和处理的组件主要就是ShuffleManager，也即shuffle管理器。

ShuffleManager随着Spark的发展有两种实现的方式，分别为HashShuffleManager和SortShuffleManager，因此spark的Shuffle有Hash Shuffle和Sort Shuffle两种。

https://www.cnblogs.com/itboys/p/9226479.html

