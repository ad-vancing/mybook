# 倒序，最新的在最前面
第n页的范围：`max_id - (n-1)*pageSize ~ max(max_id - pageSize*n + 1, 1)`

# 顺序，最旧的在最前面
第n页的范围：`pageSize*(n -1) ~ (pageSize*n - 1)  `
如第一页范围：0-9  

# redis实现分页查询
利用栈，Lpush、LRANGE

# mysql分页查询优化
https://blog.csdn.net/weixin_41011482/article/details/97031275

随着表数据量的增加，复杂join查询或者复杂嵌套查询，直接使用limit分页查询会越来越慢。

eg1:
`select id,name from product limit 866613, 20`

使用上述SQL语句优化的方法如下：可以取前一页的最大行数的id，然后根据这个最大的id来限制下一页的起点。
比如此列中，上一页最大的id是866612。SQL可以采用如下的写法：

`select id,name from product where id> 866612 limit 20`



eg2:
`select * from test1 where c1>202 limit 10000,10`
首先在c1普通索引树上获取到limit限制的 id主键值，然后再根据主键值去聚簇索引树上查询出需要的数据即可。
常见的分页sql语句一般也是这样写，往后翻页时速度跟翻第一页一样快；

`select b.* from (select id from test1 where c1>202 limit 10000,10)a, test1 b where a.id=b.id`

思路都是充分利用索引。

## 其他路子
[使用SQL_CALC_FOUND_ROWS和SELECT found_rows()优化分页查询](https://www.jianshu.com/p/f20e06291ac9)