[dbz介绍](https://loujitao.github.io/Debezium%E7%AE%80%E4%BB%8B-%E4%B8%80/)
https://www.cnblogs.com/xiongmozhou/p/14991623.html
[dbz源码解读](https://blog.csdn.net/zhengzaifeidelushang/article/details/125646899)

# 安装配置debezium
下载：
wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/1.8.1.Final/debezium-connector-postgres-1.8.1.Final-plugin.tar.gz
解压压缩包：tar -zxvf debezium-connector-postgres-1.8.1.Final-plugin.tar.gz
/Users/guanliyuan/Desktop/0318/openTool/kafka-docker/kfk/kafka_2.12-3.0.0/conn/debezium-connector-postgres

Streamsets？
其他同步方式参考：https://jiagoushi.pro/postgresql-cdc-how-set-real-time-sync

[清爽版](https://www.jianshu.com/p/a93fa3b8de3f)
https://blog.csdn.net/qq_38626589/article/details/108217681

# 原理
https://blog.nowcoder.net/n/8ce3f3049a054d9b99bc5371910f3b9f
它通过同步WAL记录实现从PostgreSQL抓取数据的功能
https://blog.csdn.net/foshansuperinter/article/details/110903708
https://www.infoq.cn/article/lp5ucrKTI3V4aW1PWvxm

逻辑解码（Logical Decoding），用于从 WAL 日志中解析逻辑变更事件

复制协议（Replication Protocol）：提供了消费者实时订阅（甚至同步订阅）数据库变更的机制

快照导出（export snapshot）：允许导出数据库的一致性快照（pg_export_snapshot）

复制槽（Replication Slot），用于保存消费者偏移量，跟踪订阅者进度。

WAL(Write-Ahead Logging, 预写式日志)

## 逻辑复制
dbz 的 pg connector 从逻辑副本流中读取数据
https://blog.csdn.net/bisal/article/details/119156524
1、逻辑复制的前提是将数据库wal_level参数设置成logical。`select setting from pg_settings where name='wal_level';`
2、源库上逻辑复制的用户必须具有replicatoin或superuser角色。
3、需要发布逻辑复制的表，须配置表的REPLICA IDENTITY特性。
逻辑复制目前仅支持数据库表逻辑复制，其它对象例如函数、视图不支持。
逻辑复制支持DML(UPDATE、INSERT、DELETE)操作，TRUNCATE 和 DDL 操作不支持。
需要编码器，例如 pgoutput 把WAL解释成其他应用可以理解的格式

### Publication (发布):
发布是从一个表或一组表中生成的一组更改，也可能被描述为更改集或复制集。每个发布只存在于一个数据库中，经创建Publication的数据库成为发布节点，一个数据库可以创建多个Publication。
而Publication的对象只能是表，可以把需要被监控的多个表配置到一个发布中。
SELECT * from pg_publication
允许一次发布所有表，CREATE PUBLICATION alltables FOR ALL TABLES;
CREATE PUBLICATION hhh FOR TABLE "public".station
select * from pg_publication_tables where tablename='temp_tb';
被复制的表上最好有主键约束；如果没有，必须执行 ALTER TABLE tablename REPLICA IDENTITY FULL;

#### REPLICA IDENTITY，复制标识，共有4种配置模式
`select relreplident from pg_class where relname='tablename';`
d = 默认(主键，如果存在)
n = 无
f = 所有列
i = 索引的indisreplident被设置或者为默认
(1) 默认模式(default)：
非系统表采用的默认模式，如果有主键，则用主键列作为身份标识，否则用完整模式。
(2) 索引模式(index)：将某一个符合条件的索引中的列，用作身份标识。
(3) 完整模式(full)：将整行记录中的所有列作为复制标识(类似于整个表上每一列共同组成主键，使用FULL模式的复制标识效率很低，所以这种配置只能是保底方案，或者用于很小的表。因为每一行修改都需要在订阅者上执行全表扫描，很容易将订阅者拖垮)。
(4) 无身份模式(nothing)：不记录任何复制标识，这意味着UPDATE|DELETE操作无法复制到订阅者上。
ALTER TABLE tablename REPLICA IDENTITY { DEFAULT | USING INDEX index_name | FULL | NOTHING };

Subscription(订阅): 被配置到需要同步数据的PostgreSQL实例上，能实时同步发布节点指定的数据表。

Replication slots（复制槽）: 定义在发布节点上，记录了订阅节点的数据复制情况。一个订阅节点占用一个复制槽。
这样，若订阅节点宕机，发布节点会根据复制槽内记录的数据复制情况，不会清除订阅节点未复制的WAL日志。



# 日志相关
PostgreSQL有3种日志，分别是pg_log（数据库运行日志）、pg_xlog（WAL 日志，即重做日志）、pg_clog（事务提交日志，记录的是事务的元数据）
pg_log默认是关闭的，需要设置参数启用此日志。pg_xlog和pg_clog都是强制打开的，无法关闭。

# conn 创建参数
https://blog.csdn.net/foshansuperinter/article/details/110856979
每个被监控的表在Kafka都会对应一个topic，topic的命名规范是<database.server.name>.<schema>.<table>
两个表的数据变更消息将保存到Kafka的topic debezium.inventory.orders 和debezium.inventory.products中

```
{
    "name": "inventory-connector",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": "postgres",
        "database.port": "5432",
        "database.user": "postgres",
        "database.password": "postgres",
        "database.dbname": "postgres",
        "database.server.name": "debezium",
        "slot.name": "inventory_slot", 
        "table.include.list": "inventory.orders,inventory.products",
        "publication.name": "dbz_inventory_connector",
        "publication.autocreate.mode": "filtered",
        "plugin.name": "pgoutput"
    }
}
```
## slot.name
PostgreSQL的复制槽(Replication Slot)名称? 可以不传吗？
```
    {
        "name": "pg-1-connector",
         "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": "172.22.50.197",
        "database.port": "5432",
        "database.user": "postgres",
        "database.password": "mikeops",
        "database.dbname": "testdd",
        "database.server.name": "pg-1",
        "table.include.list": "testschema.station",
        "publication.name": "test_publication",
        "publication.autocreate.mode": "filtered",
        "plugin.name": "wal2json"
    }

 unrecoverable exception. Task is being killed and will not recover until manually restarted (org.apache.kafka.connect.runtime.WorkerTask:193)
io.debezium.DebeziumException: Creation of replication slot failed
	at io.debezium.connector.postgresql.PostgresConnectorTask.start(PostgresConnectorTask.java:143)
	at io.debezium.connector.common.BaseSourceTask.start(BaseSourceTask.java:130)
	at org.apache.kafka.connect.runtime.WorkerSourceTask.execute(WorkerSourceTask.java:232)
	at org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:186)
	at org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:241)
	at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
	at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
	at java.base/java.lang.Thread.run(Unknown Source)
Caused by: org.postgresql.util.PSQLException: ERROR: could not access file "wal2json": No such file or directory
	at org.postgresql.core.v3.QueryExecutorImpl.receiveErrorResponse(QueryExecutorImpl.java:2675)
	at org.postgresql.core.v3.QueryExecutorImpl.processResults(QueryExecutorImpl.java:2365)
	at org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:355)
	at org.postgresql.jdbc.PgStatement.executeInternal(PgStatement.java:490)
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:408)
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:329)
	at org.postgresql.jdbc.PgStatement.executeCachedSql(PgStatement.java:315)
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:291)
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:286)
	at io.debezium.connector.postgresql.connection.PostgresReplicationConnection.createReplicationSlot(PostgresReplicationConnection.java:360)
	at io.debezium.connector.postgresql.PostgresConnectorTask.start(PostgresConnectorTask.java:136)
	... 9 more
[2022-06-26 19:51:58,013] INFO [pg-1-connector|task-0] Stopping down connector (io.debezium.connector.common.BaseSourceTask:238)
```

Debeziumhui会在PostgreSQL创建一个名为inventory_slot的复制槽，本例中创建的connector需要通过该复制槽获取数据变更的信息。
https://www.postgresql.org/docs/current/warm-standby.html#STREAMING-REPLICATION-SLOTS-MANIPULATION

## plugin.name	PostgreSQL
逻辑解码器输出插件，用于将数据作为协议缓冲区传送
服务端安装的解码插件名称，可以是decoderbufs, wal2json, wal2json_rds, wal2json_streaming, wal2json_rds_streaming 和 pgoutput。如果不指定该值，则默认使用decoderbufs。
本例子中使用了pgoutput，因为它是PostgreSQL 10+自带的解码器，而其他解码器都必须在PostgreSQL服务器安装插件。

## publication.name	
PostgreSQL端的WAL发布(publication)名称，每个Connector都应该在PostgreSQL有自己对应的publication，
如果不指定该参数，那么publication的名称为 dbz_publication

## publication.autocreate.mode
该值在plugin.name设置为pgoutput才会有效。有以下三个值：

all_tables - debezium会检查publication是否存在，如果publication不存在，connector则使用脚本CREATE PUBLICATION <publication_name> FOR ALL TABLES创建publication，即该发布者会监控所有表的变更情况。

disabled - connector不会检查有无publication存在，如果publication不存在，则在创建connector会报错.

filtered - 与all_tables不同的是，debezium会根据connector的配置中的table.include.list生成生成创建 publication 的脚本： CREATE PUBLICATION <publication_name> FOR TABLE <tbl1, tbl2, tbl3>。例如，本例子中，“table.include.list"值为"inventory.orders,inventory.products”，则publication只会监控这两个表的变更情况。
Creating new publication 'test0_publication' for plugin 'PGOUTPUT'


op为c (create)
op为u (update)
op为d (delete)
op": "t"(truncate)
r:read

# 我的
curl -XPOST -H "content-type: application/json" http://localhost:8083/connectors -d @mysql-connector-example.json

```
{
    "name": "POSTGRESQL-1111",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "value.converter.schemas.enable": "true",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "database.hostname": "172.22.50.197",
        "database.port": "5432",
        "database.user": "postgres",
        "database.password": "mikeops",
        "database.dbname": "testdd",
        "tasks.max": "1",
        "database.history.kafka.bootstrap.servers": "zk-kafka-c-0.zk-kafka-c.kube-data.svc.cluster.local:9092",
        "database.history.kafka.topic": "POSTGRESQL-1111-history",
        "database.server.name": "POSTGRESQL-1111",
        "slot.name": "inventory_slot", 
        "table.include.list": "inventory.orders",
        "plugin.name": "pgoutput"

        "publication.name": "dbz_inventory_connector",
        "publication.autocreate.mode": "filtered",

    }
}
```

## conn create
### 1、fetch wal_level
Postgres server wal_level property must be \"logical\"
{
    "error_code": 400,
    "message": "Connector configuration is invalid and contains the following 1 error(s):\nPostgres server wal_level property must be \"logical\" but is: replica\nYou can also find the above list of errors at the endpoint `/connector-plugins/{connectorType}/config/validate`"
}
SHOW wal_level

PostgreSQL 11 the parameter wal_level can have 3 values:
-minimal : only information needed to recover from a crash or an immediate shutdown。不能通过基础备份和wal日志恢复数据库。
-replica : enough data to support WAL archiving and replication （默认）。支持wal归档和复制。
-logical : enough information to support logical decoding. 在replica级别的基础上添加了支持逻辑解码所需的信息

修改：
配置文件postgresql.conf，修改wal_level = logical
docker restart

### 2、check user for LOGIN and REPLICATION roles
Postgres roles LOGIN and REPLICATION are not assigned to user

SELECT r.rolcanlogin AS rolcanlogin, r.rolreplication AS rolreplication, 
 CAST(array_position(ARRAY(SELECT b.rolname 
 FROM pg_catalog.pg_auth_members m 
 JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid) 
 WHERE m.member = r.oid), 'rds_superuser') AS BOOL) IS TRUE AS aws_superuser 
, CAST(array_position(ARRAY(SELECT b.rolname 
 FROM pg_catalog.pg_auth_members m 
 JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid) 
 WHERE m.member = r.oid), 'rdsadmin') AS BOOL) IS TRUE AS aws_admin 
, CAST(array_position(ARRAY(SELECT b.rolname 
 FROM pg_catalog.pg_auth_members m 
 JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid) 
 WHERE m.member = r.oid), 'rdsrepladmin') AS BOOL) IS TRUE AS aws_repladmin 
 FROM pg_roles r WHERE r.rolname = current_user
 

### 3、check publication
 Unable to create filtered publication dbz_publication
 
 Caused by: io.debezium.DebeziumException: No table filters found for filtered publication dbz_inventory_connector
 	at io.debezium.connector.postgresql.connection.PostgresReplicationConnection.initPublication(PostgresReplicationConnection.java:156)

-- 设置发布开关
update pg_publication set puballtables=true where pubname is not null;
Puballtables：是发布数据库中的所有表，t表示发布数据库中所有已存在的表和以后新建的表

-- 创建发布 test_publication，添加所有表到 test_publication，包括以后新建的表
CREATE PUBLICATION test_publication FOR ALL TABLES;
CREATE PUBLICATION hhh FOR TABLE "public".station

-- 查询哪些表已经发布
select * from pg_publication_tables;

### 4、use a distinct replication slot name
 when setting up multiple connectors for the same database host, please make sure to use a distinct replication slot name for each.
 replication slot "inventory_slot" is active for PID 3273
 
 逻辑解码槽/复制槽:replication slots保存了逻辑或物理流复制的基础信息。(debe来创建)
 select * from pg_replication_slots;
 
 似乎只需要 slot.name 不一样
 
 指定名字后，dbz会自动执行：
 `CREATE_REPLICATION_SLOT "inventory_slot1"  LOGICAL wal2json`
 Creating replication slot with command CREATE_REPLICATION_SLOT "inventory_slot110"  LOGICAL pgoutput
 ```
创建physical slot
SELECT * FROM pg_create_physical_replication_slot('my_rep_slot_1');
创建logic slot函数，需要指定解码器：
SELECT * FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding');
```

 ### 5、发现 update 的都没有 before
 ```
 "before": null,
    "after": {
      "id": 9,
      "routecode": "80",
      "description": "555"
    },
```
plugin 有关吗？
The pgoutput plug-in does not emit all events for tables without primary keys. It emits only events for INSERT operations.
Supported values are decoderbufs, wal2json, wal2json_rds, wal2json_streaming, wal2json_rds_streaming and pgoutput.
If you are using a wal2json plug-in and transactions are very large, the JSON batch event that contains all transaction changes might not fit into the hard-coded memory buffer, which has a size of 1 GB. In such cases, switch to a streaming plug-in, by setting the plugin-name property to wal2json_streaming or wal2json_rds_streaming. With a streaming plug-in, PostgreSQL sends the connector a separate message for each change in a transaction.

是少一个设置：
-- 更改复制标识包含更新和删除之前值
ALTER TABLE station REPLICA IDENTITY FULL;

### 6、Caused by: org.postgresql.util.PSQLException: ERROR: all replication slots are in use
Hint: Free one or increase max_replication_slots.
```
 show max_replication_slots
 select slot_name from pg_replication_slots where active = 'f' and active_pid is NULL;
 select * from pg_replication_slots ;
 --删除 
 SELECT pg_drop_replication_slot('inventory_slot');  
``` 

1、post请求前，删除 pg inactive 的 slot
2、停止后，删除本次使用的slot？

https://blog.csdn.net/xiaohai928ww/article/details/102966787?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-102966787-blog-106810187.pc_relevant_aa&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-102966787-blog-106810187.pc_relevant_aa&utm_relevant_index=1

# dbz converter 时间类型
https://blog.csdn.net/weixin_40747900/article/details/123281851
https://www.saoniuhuo.com/question/detail-1965017.html
https://blog.csdn.net/XAGU_/article/details/121037467
https://debezium.io/documentation/reference/1.8/development/converters.html

付费专栏：
https://blog.csdn.net/zhengzaifeidelushang/category_11240845_2.html

# "mode" : "incrementing",？

# Data duplication problem using postgresql source on debezium server
https://issues.redhat.com/browse/DBZ-5070