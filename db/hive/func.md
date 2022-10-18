[函数大全](https://blog.csdn.net/GodSuzzZ/article/details/106793445)
[函数](https://blog.csdn.net/weixin_39818014/article/details/112092693)

--1. 获取当前日期和时间（年月日时分秒）
--写法一：
select from_unixtime(unix_timestamp(),"yyyy-MM-dd HH:mm:ss")
2020-04-21 11:02:55

select from_unixtime(cast(operationtime/1000 as int), 'yyyy/MM/dd HH:mm:ss') 
from data_sync.test1_real;

--写法二：
select substr(current_timestamp(),1,19)
2020-04-21 11:02:55


-- 2.获取当前日期
--写法一：
select from_unixtime(unix_timestamp(),"yyyy-MM-dd")
2020-04-21
--写法二：（推荐）
select current_date()或者select current_date
2020-04-21
-- 写法三：
select substr(current_timestamp(),1,10)
2020-04-21