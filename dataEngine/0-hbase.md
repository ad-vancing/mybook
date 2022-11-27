https://segmentfault.com/a/1190000019292741

# hbase vs hive
通过ETL工具将数据源抽取到HDFS存储；

通过Hive清洗、处理和计算原始数据；

HIve清洗处理后的结果，如果是面向海量数据随机查询场景的可存入Hbase。

HBase是Hadoop的数据库，一个分布式、可扩展、大数据的存储。部署于hdfs之上，并且克服了hdfs在随机读写方面的缺点。

hbase是物理表，不是逻辑表，提供一个超大的内存hash表，搜索引擎通过它来存储索引，解决实时数据查询问题，方便查询操作。

Hive中的表纯逻辑。

# ClickHouse和Hbase有什么区别
Hbase：不支持标准sql，需要集成Phoenix插件。Hbase自身有Scan操作，但是不建议执行，一般会全量扫描导致集群崩溃。

Clickhouse：自身有优良的查询性能

# 为什么Hbase能实现快速的查询
hbase是根据rowkey查询的，只要能快速的定位rowkey,  就能实现快速的查询。

- hbase是可划分成多个region，你可以简单的理解为关系型数据库的多个分区。
- 键是排好序了的
- 按列存储的


# HBase的数据的update
hbase是以rowkey，column，timestamp这三个维度来区分的。如果两条记录其rowkey，column，timestamp一样的话，那么hbase就会认为其是相同的数据。

