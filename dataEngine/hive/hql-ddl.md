https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable

# 查看
show create table student;

desc formatted student;

desc student;

DESCRIBE EXTENDED student

show partitions table_name  

# DDL
```
create table if not exists tab_partition_bucket(
id int,
name string,
age int
)
partitioned by (province string)
clustered by (id) sorted by (id desc) into 3 buckets
row format delimited
fields terminated by ','
stored as orc;
```

## 创建一个模式一样的新表
CREATE TABLE new_table LIKE existing_table;

CREATE TABLE new_table AS SELECT * FROM existing_table; 


## 重命名
对于内部表，除了更新表的元数据之外，还对表的目录名称进行修改。
对于外部表，这个操作只更新元数据，但不会更改存放数据的目录名称。
alter table student rename to students;

## 添加新列
alter table students
add columns(id int); --增加id列，类型int

## 修改列
alter table t081901
change column old_col --要进行修改的列名
new_col int; --修改后的列名和数据类型

## 替换【重置】表的列名和类型
将原有的列删除，然后再添加新的指定的列。
alter table student 
replace columns( --replace columns替换数据列
age int,
name string);

## 清空表
Hive中不支持delete table T_Name操作。
Hive中支持 truncate table T_Name操作。
对于分区表，它是将各个分区下面的数据文件删除，但是分区的目录还存在。
相当于执行了以下命令：hive > dfs -rmr /user/hive/warehouse/my_table;

## 分区重命名
ALTER TABLE table_name PARTITION partition_spec RENAME TO PARTITION partition_spec;

## 增加分区【Add Partition】
hive> alter table logs add                                            
    > partition(date='2015-01-03',country='USA')      --分区                
    > location '/user/hive/warehouse/logs/date=2015-01-03/country=USA' --分区路径


## 按分区删除    
alter table logs drop partition(date='2015-01-03',country='USA');   

## 元数据检查命令修复表
Recover Partitions (MSCK REPAIR TABLE xxx)
hive在元数据中保存着分区信息，如果直接用 hadoop fs -put 命名在HDFS上添加分区，元数据不会意识到。
需要用户在hive上为每个新分区执行ALTER TABLE table_name ADD PARTITION，元数据才会意识到。 
这个命令会把HDFS上有的分区，但是元数据中没有的分区，补充到元数据信息中。


## 修改表的备注
ALTER TABLE table_name SET TBLPROPERTIES ('comment' = new_comment);

## 修改表的SerDe属性
ALTER TABLE table_name SET SERDEPROPERTIES ('field.delim' = ',');

## 修改表的存储属性

## Hive Transactions
https://cwiki.apache.org/confluence/display/Hive/Hive+Transactions

# insert
INSERT INTO TABLE employee SELECT * FROM ctas_employee;



## insert overwrite
insert overwrite table tabel1 VALUES (141,'华东','2020-11-19 15:38:56.116')

```
insert overwrite table tlog_bigtable  PARTITION (dt='2017-12-20',game_id = 'id')
select * from tlog_bigtable t
where t.dt = '2017-12-20'
and t.event_time < '2017-12-20 20:00:00'
and t.game_id = 'id'
```

如果 hive 表是分区表的话，insert overwrite 操作只会重写当前分区的数据，不会重写其他分区数据。

INSERT INTO TABLE employee SELECT * FROM ctas_employee;
WITH a AS (SELECT * FROM ctas_employee) FROM a INSERT OVERWRITE TABLE employee;

## 清空表：
insert overwrite table t_table1 select * from t_table1 where 1=0;

其他：
DROP TABLE [IF EXISTS] table_name  ;
TRUNCATE TABLE table_name