# 日志
执行update时，更新语句涉及到了数据的更改，所以必不可少的需要引入日志模块。
  
redo log、undo log都是InnoDB引擎特有的日志模块，redo log用于保证事务持久性（事务一旦提交，它对数据库的改变就应该是永久性的），undo log则是事务原子性和隔离性实现的基础。

binlog是Server层自带的日志模块。
## redo log重做日志
在更新数据写入内存的同时，会先更新内存记录redo log，然后顺序写入磁盘，而不是等内存占满之后再持久化，这样当数据库异常宕机之后，我们可以根据redo log重做日志来恢复数据，保证之前提交的数据不会丢失。  

各种不同操作有不同的重做日志格式。
## bin log归档日志
binlog是逻辑日志，记录本次修改的原始逻辑，说白了就是记录了修改数据的SQL语句。  
通过mysqlbinlog可以解析查看binlog日志。  

>	在今天中午12点的时候，发现上午10点执行了错误的SQL语句，想把数据库状态恢复到上午10点，错误语句执行之前。那么该怎么办呢？
	数据恢复步骤如下：
	首先你要拿到最近一次的备份库
	拿到最近备份库开始到出错时候的所有binlog（binlog日志保留时间可以自定义）
	使用binlog重放到错误发生之前。

## undo log回滚日志
主要用于事务的回滚。


# 是否开启binlog
-- log_bin对应的值是OFF，所以我们知道binlog没有开启。
show variables like 'log_bin'
show variables like 'log_%';

SELECT variable_value as "BINARY LOGGING STATUS (log-bin) ::"
FROM information_schema.global_variables WHERE variable_name='log_bin';
从mysql5.7.6开始information_schema.global_status已经开始被舍弃，为了兼容性，此时需要打开 show_compatibility_56
https://blog.csdn.net/shimengran107/article/details/103991960

## MySQL binlog有三种模式：Row、Statement（默认） 和 Mixed 。
是否开启行模式  row
show global variables like "%binlog_format%";

SET global binlog_format='ROW';

SELECT variable_value as "binlog_format"
FROM information_schema.global_variables WHERE variable_name='binlog_format';
-- 是否补全所有字段  full
show global variables like "binlog_row_image";

set  binlog_row_image ='minimal';

SELECT variable_value as "binlog_row_image"
FROM information_schema.global_variables WHERE variable_name='binlog_row_image';


在MySQL 5.7以后binlog的格式默认就是ROW了，同时引入了新的参数binlog_row_image，这个参数默认值是FULL，其还有一个值是minimal。
FULL记录每一行的变更，minimal只记录影响后的行。
参考：https://www.cnblogs.com/gomysql/p/6155160.html