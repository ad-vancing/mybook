TIMESTAMPTZ and TIMETZ

https://debezium.io/documentation/reference/1.8/connectors/postgresql.html
搜 Basic types

PostgreSQL 提供两种存储时间戳的数据类型： 不带时区的 TIMESTAMP 和带时区的 TIMESTAMPTZ。
TIMESTAMP 数据类型可以同时存储日期和时间，但它不存储时区。这意味着，当修改了数据库服务器所在的时区时，它里面存储的值不会改变。
在向 TIMESTAMPTZ 字段插入值的时候，PostgreSQL 会自动将值转换成 UTC 值，并保存到表里。（TIMESTAMPTZ并不会存储时区，它只是存储了UTC值，然后和当前时区进行转换。）
当从一个 TIMESTAMPTZ 字段查询数据的时候，PostgreSQL 会把存储在其中的 UTC 值转换成数据库服务器、用户或当前连接所在的时区。


