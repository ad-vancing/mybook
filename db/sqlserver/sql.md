

# create
create table test_ts
(
    a int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ts TIMESTAMP,
    datetime1 DATETIME,
    date1 DATE NULL
);

在sqlserver中，timestamp的作用是给每行的数据加上版本标志，但这个标志和时间没有任何关系，可以将它看成是byte[8]数组并且是数据库全局自增的。
timestamp或被弃用


# TIMEZONE
SELECT CURRENT_TIMEZONE();


# time
SELECT SYSDATETIMEOFFSET();

[Debezium时间戳相比数据库多了8小时](https://blog.csdn.net/XAGU_/article/details/121037467)

# version
SELECT @@VERSION

# datetime => varchar
SELECT COUNT(*) from dbo.test_2022 WHERE CONVERT(VARCHAR(10),jiaoyisj,120 )= '2022-06-21'

