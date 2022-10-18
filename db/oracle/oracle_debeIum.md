
插件：
https://repo1.maven.org/maven2/io/debezium/debezium-connector-oracle/1.8.1.Final/debezium-connector-oracle-1.8.1.Final-plugin.tar.gz
/Users/guanliyuan/Desktop/0318/openTool/kafka-docker/kfk/kafka_2.12-3.0.0/conn/debezium-connector-oracle


https://blog.csdn.net/weixin_40898246/article/details/120880414?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-120880414-blog-122684748.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-120880414-blog-122684748.pc_relevant_default&utm_relevant_index=1

[spark离线同步oracle，number类型转int](https://cloud.tencent.com/developer/article/1197194)
[java debzium](https://blog.csdn.net/qq_41306240/article/details/120873870)

[debezium FAQ](https://debezium.io/documentation/faq)

    {
        "name": "oracle-0-connector",
        "config": {
            "connector.class": "io.debezium.connector.oracle.OracleConnector",
            "database.user": "oracle",
            "database.dbname": "XE",
            "tasks.max": "1",
            "database.history.kafka.bootstrap.servers": "localhost:9092",
            "database.history.kafka.topic": "x0.history",
            "database.server.name": "XE",
            "database.port": "49161",
            "database.hostname": "192.168.0.108",
            "database.password": "oracle11",
            "value.converter.schemas.enable": "true",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "table.include.list": "ORACLE.STU",
            "schemas.enable": "true",  //?
            "database.connection.adapter": "logminer",
            "log.mining.strategy": "online_catalog",//读取redolog,redolog写满才会生成归档日志，导致topic接收数据慢。这种 无法正确处理对表进行的 DDL 更改
            "snapshot.mode" : "initial",//快照模式,initial 连接器启动的时候，它会默认执行一次数据库初始的一致性快照任务
            "decimal.handling.mode": "string", //number类型乱码解决
            "snapshot.mode": "schema_only"//取消快照
        }
    }
    
    
    {
        "name": "op", 
        "config": {
            "connector.class" : "io.debezium.connector.sqlserver.SqlServerConnector",
            "tasks.max" : "1",
            "database.server.name" : "l",
            "database.hostname" : "172.22.50.197",
            "database.port" : "1433",
            "database.user" : "sa",
            "database.password" : "OcP2020123",
            "database.dbname" : "demo",
            "schemas.enable" : "true", //?
            "table.include.list" : "dbo.sync01",
            "mode":"incrementing",  //???
            "database.history.kafka.bootstrap.servers" : "localhost:9092",
            "database.history.kafka.topic": "l.dbo.sync01.history",
            "value.converter.schemas.enable":"true",
            "value.converter":"org.apache.kafka.connect.json.JsonConverter" 
        }
    }
# snapshot.mode    不太懂
[snapshot.mode](https://blog.csdn.net/lzufeng/article/details/81606825)  
https://debezium.io/documentation/reference/1.8/connectors/postgresql.html#postgresql-property-snapshot-mode
- initial 
表示指定connector在logic server name 没有offset记录 的情况下，会运行一次snapshot。(默认值)

- when_needed 
这表示connector在启动的时候，判断是否需要运行snapshot。当没有offsets数据，或者之前的binlog offset记录或者 GTID 在mysql服务器上面，找不到了。

配置binlog超过现有的可读binlog范围，则会强制触发一个snapshot。(手动修改 kafka-connect distribute版本的内建kafka对列：connect-offsets 的值，达到这个效果）

never 

nerver表示，不会使用snapshot操作，所以当启动connector的时候，会根据logical server name，会从binlog的最开始处进行数据读取。这需要谨慎地使用，因为只有在binlog数据包含了所有的数据库历史记录的时候，才会有效。

如果你不需要topics包含一致性历史快照，且只需要增量变化的数据，那么可以使用schema_only。

(D) schema_only

只对表结构进行snapshot，数据会按照增量的形式进行添加。

"snapshot.mode": "schema_only",      //选择schema_only，从当前最新的位点开始同步，不需要冷数据，冷数据用其他方式抽取？？？

(E) schema_only_recovery 

schema_only_recovery 用于修复一个现有的connector，因为崩溃 或者丢失数据库历史topic，或者是周期性执行了clean up操作，清空了数据库历史topic(database history topic). 它不会同步任何数据，只是将schema修复到与数据库一致。 

# log.mining.strategy
online_catalog
因为此策略显式切换 LogMiner 会话上的DICT_FROM_ONLINE_CATALOG选项，而不是DDL_DICT_TRACKING + DICT_FROM_REDO_LOGS。因此，如果表已更改并且 LogMiner 读取的表版本号与当前数据库的在线词典版本不同，则返回的数据将带有这些名为COL1、COL2、 .... COLn的合成列名称。


# database.history.store.only.monitored.tables.ddl = true
由于History存放是表结构变更的数据，而且过期时间为无限，所以时间久了，History的topic会变得非常大。


[oracle的ddl监控](https://issues.redhat.com/browse/DBZ-3401)  

# decimal.handling.mode
 is set to precise, the connector uses the Kafka Connect org.apache.kafka.connect.data.Decimal logical type for all DECIMAL, NUMERIC and MONEY columns. This is the default mode.
 https://debezium.io/documentation/reference/1.8/connectors/postgresql.html
 搜 Decimal types
 
 
# 问题
1、Caused by: java.sql.SQLException: ORA-06550: line 1, column 115:
  [PLS-00201: identifier 'DBMS_LOGMNR' must be declared

GRANT EXECUTE_CATALOG_ROLE TO USER; 