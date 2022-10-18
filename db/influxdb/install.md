# 时间序列数据库
简称时序数据库，Time Series Database，最大的特点就是每个条数据都带有Time列。
业务场景————监控系统。

特点：
1. 支持类似SQL的查询语法
2.提供了Http Api直接访问

[版本区别]()
1.x 版本使用 influxQL 查询语言，
2.x 和 1.8+（beta） 使用 flux 查询语法；相比V1 移除了database 和 RP，增加了bucket。

## influxDB中独有的概念
https://docs.influxdata.com/influxdb/v2.2/reference/key-concepts/data-elements/

https://docs.influxdata.com/influxdb/v1.8/concepts/glossary/#influxdb-line-protocol

series ：所有在数据库中的数据，都需要通过图表来表示，series（系列）表示这个表里面的所有的数据可以在图标上画成几条线（注：线条的个数由tags排列组合计算出来）、
point ： 表里面的一行数据、由时间戳（time 每个数据记录时间，是数据库中的主索引(会自动生成)）、数据（field ）和标签（tags ）、measurement 组成。
measurement ： 相当于数据库中的表。
time的列，里面存储UTC时间戳，并以 RFC3339 UTC 格式展示。time 相当于表的主键，当一条数据的time和tags完全相同时候，新数据会替换掉旧数据，旧数据则丢失（线上环境尤其要注意）
fields ：字段、数据（没有索引的属性），记录的度量值：如温度， 湿度
field key  、
field value : Field values can be strings, floats, integers, or booleans
field set、
tags: 各种有索引的属性：地区，海拔 
tag key 、
tag value、
tag set、

字段必须存在。因为字段是没有索引的。如果使用字段作为查询条件，会扫描符合查询条件的所有字段值，性能不及tag。类比一下，fields相当于SQL的没有索引的列。
tags是可选的，但是强烈建议你用上它，因为tag是有索引的，tags相当于SQL中的有索引的列。tag value只能是string类型。
time 相当于表的主键，当一条数据的time和tags完全相同时候，新数据会替换掉旧数据，旧数据则丢失（线上环境尤其要注意）

### shard
shard是InfluxDB存储引擎的实现，负责数据的编码存储、读写服务等。将InfluxDB中时间序列化的数据按照时间的先后顺序存入到shard中，每个shard中都负责InfluxDB中一部分的数据存储工作，并以tsm文件的表现形式存储在物理磁盘上，每个存放了数据的shard都属于一个shard group。
shard group可以理解为存放shard的容器，所有的shard在逻辑上都属于这个shard group，每个shard group中的shard都有一个对应的时间跨度和过期时间，每一个shard group都有一个默认的时间跨度，叫做shard group duration。
https://jasper-zhang1.gitbooks.io/influxdb/content/Query_language/schema_exploration.html

### v2新增的概念：
bucket：所有 InfluxDB 数据都存储在一个存储桶中。一个桶结合了数据库的概念和存储周期（时间每个数据点仍然存在持续时间）。一个桶属于一个组织
bucket schema：具有明确的schema-type的存储桶需要为每个度量指定显式架构。测量包含标签、字段和时间戳。显式模式限制了可以写入该度量的数据的形状。
organization：InfluxDB组织是一组用户的工作区。所有仪表板、任务、存储桶和用户都属于一个组织。

# v1.79 安装
https://docs.influxdata.com/influxdb/v1.7/
docker pull influxdb:1.7.9
docker run --rm -p 8084:8083 -p8086:8086 --expose 8090 --expose 8099 --name influx179 influxdb:1.7.9
docker run -itd -p 8084:8083 -p8086:8086 --expose 8090 --expose 8099 --name influx179 influxdb:1.7.9

# v1.8 安装
docker pull influxdb:1.8
docker run --rm -p 8083:8083 -p8086:8086 --expose 8090 --expose 8099 --name influx18 influxdb:1.8
docker run -itd -p 8083:8083 -p8086:8086 --expose 8090 --expose 8099 --name influx18 influxdb:1.8
```
cyandeMacBook-Pro:~ guanliyuan$ docker exec -it influx18 bash
root@ee91ca0813ca:/# influx
Connected to http://localhost:8086 version 1.8.10
InfluxDB shell version: 1.8.10
> create user cyan with password 'cyan'  with all privileges;
> show users;
user  admin
----  -----
admin true
cyan  true
> DROP USER "cyan"

GRANT ALL TO "jdoe"

-- grant read access to a database
GRANT READ ON "mydb" TO "jdoe"
```

[配置文件说明](https://www.cnblogs.com/guyeshanrenshiwoshifu/p/9188368.html)
[权限相关   ](https://blog.hhui.top/hexblog/2019/05/05/190505-InfluxDB%E4%B9%8B%E6%9D%83%E9%99%90%E7%AE%A1%E7%90%86/)


# v2.0安装
docker run --rm -p 8083:8083 -p8086:8086 --expose 8090 --expose 8099 --name influxERP influxdb

8083：访问web页面的地址，8083为默认端口； http://localhost:8086

8086：数据写入influxdb的地址，8086为默认端口；

8088：数据备份恢复地址，8088为默认端口；

[参考](https://docs.influxdata.com/influxdb/v2.0/get-started/)

```
root@971ae7abe59a:/# influx version
Influx CLI 2.3.0 (git: 88ba346) build_date: 2022-04-06T19:30:53Z



root@971ae7abe59a:/# influx setup
> Welcome to InfluxDB 2.0!
X Sorry, your reply was invalid: Value is required
? Please type your primary username  root
? Please type your password ****
X Sorry, your reply was invalid: value is too short. Min length is 8
? Please type your password ********
? Please type your password again ********
? Please type your primary organization name txcloud
? Please type your primary bucket name bucket
? Please type your retention period in hours, or 0 for infinite 2
? Setup with these parameters?
  Username:           root
  Organization:      txcloud
  Bucket:            bucket
  Retention Period:  2h0m0s
 (y/N) y
```










camel?
https://camel.apache.org/components/3.17.x/debezium-sqlserver-component.html
https://camel.apache.org/components/3.17.x/debezium-summary.html


[深入研究](https://www.freesion.com/article/9235282442/)