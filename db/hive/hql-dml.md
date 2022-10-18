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