[java api](https://blog.csdn.net/x541211190/article/details/83216589)
[参考](https://docs.influxdata.com/influxdb/v1.8/introduction/get-started/)
# 库
-- 查看所有的数据库
show databases;
create database testdb;
DROP DATABASE "mydb";
-- 使用特定的数据库
use database_name;

# SELECT 
https://docs.influxdata.com/influxdb/v1.8/query_language/explore-data/#the-basic-select-statement
SELECT <field_key>[,<field_key>,<tag_key>] FROM <measurement_name>[,<measurement_name>]
FROM <database_name>.<retention_policy_name>.<measurement_name>
FROM <database_name>..<measurement_name>

SELECT后面查询显示字段必须至少有一个field key

## 时间戳查询
秒级：
select * from disk where time >= 1542954639s and time <= 1542964713s
毫秒级:
select * from disk where time >= 1542954639000ms and time <= 1542964714000ms
微秒级:
select * from disk where time >= 1542954639000000us and time <= 1542964714000000ums
纳秒级：
select * from disk where time >= 1542954639000000000ns and time <= 1542964714000000000ns
调整时区查询（北京时间）
select * from disk where time >= '2018-11-23 14:30:39' and time <= '2018-11-23 14:32:32' tz('Asia/Shanghai')

# insert
insert test,host=127.0.0.1,monitor_name=test1,app=ios count=2,num=3

[api方式](https://www.cnblogs.com/waitig/p/6072557.html)


```
A point with the measurement name of cpu 
                            and tags host and region has now been written to the database, 
                            with the measured value of 0.64.
> INSERT cpu,host=serverA,region=us_west value=0.64
> INSERT cpu,host=serverB,region=us_east value=0.84

tags 与 fields 用空格分开
<measurement>[,<tag-key>=<tag-value>...] <field-key>=<field-value>[,<field2-key>=<field2-value>...] [unix-nano-timestamp]

> SELECT "host", "region", "value" FROM "cpu"
name: cpu
time                host    region  value
----                ----    ------  -----
1655198576260060800 serverA us_west 0.64
```


## insert demo
参考：https://docs.influxdata.com/influxdb/v1.7/query_language/data_exploration/
curl https://s3.amazonaws.com/noaa.water-database/NOAA_data.txt -o NOAA_data.txt
`> CREATE DATABASE NOAA_water_database`
docker cp NOAA_data.txt influx18:/NOAA_data.txt

root@ee91ca0813ca:/# influx -import -path=NOAA_data.txt -precision=s -database=NOAA_water_database
2022/06/15 07:14:33 Processed 1 commands
2022/06/15 07:14:33 Processed 76290 inserts
2022/06/15 07:14:33 Failed 0 inserts

influx -precision rfc3339 -database NOAA_water_database

`> show measurements;`
name: measurements
name
----
average_temperature
h2o_feet
h2o_pH
h2o_quality
h2o_temperature

# api
https://docs.influxdata.com/influxdb/v1.8/tools/api/
## select 
```
epoch参数、 precision，则可以设置返回的时间戳格式，格式为epoch=[h,m,s,ms,u,ns]
curl -G 'http://172.22.50.197:8086/query?db=testdb&pretty=true&u=mike&p=mikeops&epoch=ns' --data-urlencode 'q=select * from test'

curl -G 'http://localhost:8086/query' --data-urlencode 'q=show databases'

curl -G 'http://localhost:8086/query?db=testdb&pretty=true' --data-urlencode 'q=SELECT * FROM cpu'

curl -H "Accept: application/csv" -G 'http://localhost:8086/query?db=mydb' --data-urlencode 'q=SELECT * FROM "mymeas"'

curl -G 'http://localhost:8086/query?db=mydb' --data-urlencode 'q=SELECT * FROM "mymeas" WHERE "mytag1" = $tag_value' --data-urlencode 'params={"tag_value":"12"}'
请求映射$tag_value到12. InfluxDB 将标签值存储为字符串，所以必须在请求中使用双引号。

curl -G 'http://localhost:8086/query?db=mydb' --data-urlencode 'q=SELECT * FROM "mymeas" WHERE "mytag1" = $tag_value AND  "myfield" < $field_value' --data-urlencode 'params={"tag_value":"12","field_value":30}'


```
请求多个查询用分号分隔多个查询;

## create
```
$ curl -XPOST -u myusername:mypassword 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE "mydb"'

```

KILL QUERY 53 ON "myhost:8088"

# measurement
DROP MEASUREMENT "cpu"
show measurements;
-- 查询10条数据
select * from measurement_name limit 10;
-- 数据中的时间字段默认显示的是一个纳秒时间戳，改成可读格式
precision rfc3339; -- 之后再查询，时间就是rfc3339标准格式
-- 或可以在连接数据库的时候，直接带该参数
influx -precision rfc3339
-- 查看一个measurement中所有的tag key 
show tag keys
-- 查看一个measurement中所有的field key 
show field keys
-- 查看一个measurement中所有的保存策略(可以有多个，一个标识为default)
show retention policies;

# retention policy 保留策略
描述 InfluxDB 保存数据的时间（持续时间），集群中存储数据的多少副本（复制因子），以及分片组覆盖的时间范围（分片组持续时间）。每个数据库的 RP 都是唯一的，并且与测量和标签集一起定义了一个系列。
当您创建数据库时，InfluxDB 会创建一个称为autogen无限持续时间的保留策略，复制因子设置为 1，分片组持续时间设置为 7 天。
https://docs.influxdata.com/influxdb/v1.8/query_language/manage-database/#retention-policy-management

https://docs.influxdata.com/influxdb/v1.8/concepts/glossary/#retention-policy-rp

CREATE RETENTION POLICY <retention_policy_name> ON <database_name> DURATION <duration> REPLICATION <n> [SHARD DURATION <duration>] [DEFAULT]
DURATION子句确定 InfluxDB 保留数据的时间。是<duration>持续时间文字 或INF（无限）。保留策略的最短持续时间为一小时，最长持续时间为INF。
REPLICATION子句确定每个点有多少个独立副本存储在集群中。
默认情况下，复制因子n通常等于数据节点的数量。但是，如果您有四个或更多数据节点，则默认复制因子n为 3。
为确保数据立即可用于查询，请将复制因子设置n为小于或等于集群中的数据节点数。

-- Set default retention policy for mydb to 1h.cpu.
ALTER RETENTION POLICY "1h.cpu" ON "mydb" DEFAULT

-- Change duration and replication factor.
-- REPLICATION (replication factor) not valid for OSS instances.
ALTER RETENTION POLICY "policy1" ON "somedb" DURATION 1h REPLICATION 4

-- Create a database called bar with a new DEFAULT retention policy and specify the duration, replication, shard group duration, and name of that retention policy
CREATE DATABASE "bar" WITH DURATION 1d REPLICATION 1 SHARD DURATION 30m NAME "myrp"

# delete
DELETE FROM "cpu"
DELETE FROM "cpu" WHERE time < '2000-01-01T00:00:00Z'
DELETE WHERE time < '2000-01-01T00:00:00Z'

[整个java](https://github.com/Tom-shushu/InfluxDB1.xAnd2.x-SpringBoot)