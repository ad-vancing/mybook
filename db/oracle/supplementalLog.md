# Oracle中的补充日志(supplemental log)
是对重做记录中变更矢量的补充信息，增加了变更矢量记载的记录量，Oracle数据库某些功能要求启用补充日志才能正常地或更好的工作，如logminer、DG、闪回事务查询、闪回事务。

Oracle中insert、delete命令在默认情况下产生的重做记录,足以表明被修改的行的每个字段在被修改前后的值是什么，insert和delete命令的重做记录中，能找到整行的所有信息。
但是update不同于insert和delete一定会涉及一行的所有字段，同一行中其他没有被修改的字段，不会记载其修改前的值，因为没有被修改。

补充日志主要为update服务，额外记录指定字段的旧值，使得有能力分析重做日志的工具可以高度还原update命令，由于额外记录了字段的旧值，也能将其看成一种特殊的备份。

可以在数据库级别和表级别上启用。
supplemental log可以在数据库级别启动，在数据库级别启动minimal logging会记录操作的足够信息。

## 类型
select SUPPLEMENTAL_LOG_DATA_MIN min,
       SUPPLEMENTAL_LOG_DATA_PK  pk,
       SUPPLEMENTAL_LOG_DATA_UI  ui,
       SUPPLEMENTAL_LOG_DATA_FK  fk,
       SUPPLEMENTAL_LOG_DATA_ALL "all"
  from v$database; 
  
补充日志的类型有：最小补充日志、标识关键字段补充日志两大类

### 最小补充日志
是最基本的一种数据库级补充日志。
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

select supplemental_log_data_min min from v$database ;

alter database drop supplemental log data ;

凡是启用或者关闭数据库级补充日志(包括最小补充日志和另外几种日志)都会导致共享池中所有SQL命令游标非法，也就是短期之内应解析会显著上升。

### 标识关键字段补充日志
标识关键字段补充日志有四种：主键、唯一索引、外键、全体字段补充日志  
无论启用哪一种标识关键字段补充日志，都需要启用最小补充日志，4种标识关键字段的效果可以累加，不冲突。

#### 全体字段补充日志
全体字段补充日志和主键补充日志一样为无条件式的，无论哪个字段被update命令修改，所有字段(除了lob，long类型)的旧值都将被记录。
其效果相当于启用了主键补充日志的前提下既没有主键也没有非空唯一索引字段的情况，
这样几乎所有的表数据都搬到了重做日志中，不但存在当前的，历史数据也没有丢下。
对恢复操作来说比较好，但是对于lgwr和磁盘空间就不是太好，一般很少启用这样的日志。
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;

## 表级补充日志
select  log_group_type from all_log_groups where owner = upper('%s') and table_name = upper('%s')
ALL COLUMN LOGGING

只是针对某个表，没有必要在整个数据库范围启用补充日志功能，在启用表级补充日志之前，应该先启用数据库级最小补充日志
表级补充日志分为主键、唯一索引、外键、全字段和自定义5种类型，前四种和数据级对应的类型特点一致，只是在特定的表上启用。
alter table oracle.stu add supplemental log data (all) columns;

自定义字段是表级补充日志特有的功能，用户可以任意指定那些字段的旧值需要被补充记录。
alter table hr.employees add supplemental log group emp_info (first_name,last_name,email) ;

以上将first_name,last_name,email字段指派为一个名为empinfo的日志组，意思就是只要update命令修改了这3个字段中的任意一个，重做记录必须记载全部3个字段的旧值这称为有条件式的，无条件式的要加关键字always

alter table hr.employees add supplemental log group emp_info (first_name,last_name,email) always ;


特定表上的表级补充日志的启用与关闭会导致所有引用该表的SQL游标非法，会引起一段时间的硬分析增加。

