https://segmentfault.com/a/1190000040642243?utm_source=sf-homepage

create table test_ts
(
    a int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ts TIMESTAMP,
    datetime1 DATETIME,
    date1  DATE NULL
);

INSERT INTO `test`.`test_ts`( `ts`, `datetime1`, `date1`) 
VALUES (NOW(), NOW(),  NOW());


查询表的列信息：～
select column_name,data_type,column_comment from information_schema.columns as cs
where cs.table_schema ='xxl_job2' and cs.table_name= 'xxl_job_log'


https://www.javatpoint.com/mysql-bit


# 主从复制， 读写分离， 负载均衡
一个系 统的读操作远远多于写操作，因此写操作发向 master，读操作发向 slaves 进行操作（简 单的轮循算法来决定使用哪个 slave）
  
## 主从复制的几种方式：
同步复制 ： 主服务器在将更新的数据写入它的二进制日志（Binlog）文件中后，必须等待验证所 有的从服务器的更新数据是否已经复制到其中，之后才可以自由处理其它进入的事务处理 请求。

异步复制 ：主服务器在将更新的数据写入它的二进制日志（Binlog）文件中后，无需等待验证更 新数据是否已经复制到从服务器中，就可以自由处理其它进入的事务处理请求。

半同步复制 ：主服务器在将更新的数据写入它的二进制日志（Binlog）文件中后，只需等待验证其 中一台从服务器的更新数据是否已经复制到其中，就可以自由处理其它进入的事务处理请 求，其他的从服务器不用管

# 数据库分表， 分区， 分库
分表：

通过拆分表可以提高表的访问效率。 有 2 种拆分方法： 1.垂直拆分： 把主键和一些列放在一个表中， 然后把主键和另外的列放在另 一个表中。 如果一个表中某些列常用， 而另外一些不常用， 则可以 采用垂直拆分。     2.水平拆分： 根据一列或者多列数据的值把数据行放到二个独立的表中。

分区就是把一张表的数据分成多个区块，这些区块可以在一个磁盘上，也可以在不同 的磁盘上，分区后，表面上还是一张表，但数据散列在多个位置，这样一来，多块硬盘同 时处理不同的请求，从而提高磁盘 I/O 读写性能，实现比较简单。 包括水平分区和垂直分 区。 分库是根据业务不同把相关的表切分到不同的数据库中，比如 web、bbs、blog 等库。

https://blog.csdn.net/gaisidewangzhan1/article/details/80226758