# 查看参数
 set;
 
 set hive.execution.engine;
 
 # Hive设置配置参数
 当前客户端
 `set hive.execution.engine=tez;`
 
 在启动Hive之前,就可以通过Hive --conf设置
 当前客户端
`hive --hiveconf hive.cli.print.current.db=true --hiveconf hive.cli.print.header=true` 

# 使用Beeline连接Hive
前提：服务端启动hiveserver2
` ./hive --service hiveserver2`

```
  <property>
    <name>hive.server2.thrift.port</name>
    <value>10000</value>
    <description>Port number of HiveServer2 Thrift interface when hive.server2.transport.mode is 'binary'.</description>
  </property>
```


# beeline

beeline> !connect jdbc:hive2://node04:10000
beeline> !connect jdbc:hive2://spark-thrift-server-service.system-bigdata:10000/;auth=noSasl

或者：# beeline -u jdbc:hive2//node04:10000 -n root

退出连接 0: jdbc:hive2://node04:10000> !quit


# [Hive on spark? Spark on hive? 傻傻分不清楚]()

