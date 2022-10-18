# Oracle中的归档日志（Archive Log）
[管网资料](https://docs.oracle.com/cd/B19306_01/server.102/b14231/archredo.htm#:~:text=Oracle%20Database%20lets%20you%20save%20filled%20groups%20of,if%20the%20database%20is%20running%20in%20ARCHIVELOG%20mode.)
重做日志（REDO FILE）分成2部分，一个是在线重做日志文件，另外一个就是归档日志文件。

在线重做日志大小毕竟是有限的，当都写满了的时候，就面临着2个选择，第一个就是把以前在线重做日志从头擦除开始继续写，第二种就是把以前的在线重做日志先进行备份，然后对被备份的日志擦除开始写新的在线Redo File。这种备份的在线重做日志就是归档日志。

数据库如果采用这种生成归档日志的模式的话，就是归档日志模式（ARCHIVELOG模式），反之如果不生成归档日志，就是非归档日志模式（NOARCHIVELOG模式）。

由于测试服务器的配置有限，特别是磁盘空间有限，所以有可能要限制REDO文件的大小，有可能就把系统设置为NOARCHIVELOG模式了。但是在实际的生产运行环境下，基本上一定要使用ARCHIVELOG模式。

归档日志的默认位置为%oracle_home%rdbms。

# 命令
检查当前日志操作模式
SELECT name,log_mode FROM v$database;

StatementCallback; bad SQL grammar [SELECT 1 FROM V$DATABASE WHERE NAME = upper('helowin') AND LOG_MODE = 'ARCHIVELOG']; nested exception is java.sql.SQLSyntaxErrorException: ORA-00942: table or view does not exist
解决：GRANT SELECT ANY DICTIONARY TO MY_USER;


将数据库置于 ARCHIVELOG 模式
alter database archivelog;
报错：ORA-01126: database must be mounted in this instance and not open in any instance
只有在数据库处于挂载阶段时才能更改归档模式，如果我们尝试在打开状态下进行，就会出现这个错误！！！

1、先关闭数据库
sqlplus命令执行（先 su - oracle）：    
SHUTDOWN IMMEDIATE; 

2、然后装载数据库
sqlplus命令执行：
STARTUP MOUNT;

3、再改变数据库置于 ARCHIVELOG 模式
ALTER DATABASE ARCHIVELOG;

4、再打开数据库
ALTER DATABASE OPEN;

查看归档日志信息
日志操作模式,归档位置,自动归档机器要归档的日志序列号等
ARCHIVE LOG LIST
```
Database log mode 　　　　　　No Archive Mode  
Automatic archival　　　　　　Disabled  
Archive destination　　　　　 /export/home/oracle/product/8.1.7/dbs/arch  
Oldest online log sequence 　 28613  
Current log sequence　　　　　28615

Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     3
Next log sequence to archive   4
Current log sequence	       4
```

归档日志文件名、归档日志对应的日志序列号、标识归档日志的起始SCN值
select name, sequence#, first_change# FROM v$archived_log;

其他：
SELECT destination FROM v$archive_dest;
SELECT * FROM v$loghist;
SELECT * FROM v$archive_processes;  


操作过程：
```
[oracle@d93334d5ada7 bin]$ export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_2/bin
[oracle@d93334d5ada7 bin]$ echo $ORACLE_HOME
/home/oracle/app/oracle/product/11.2.0/dbhome_2/bin
[oracle@d93334d5ada7 bin]$ $ORACLE_HOME/sqlplus / as sysdba
Error 6 initializing SQL*Plus
SP2-0667: Message file sp1<lang>.msb not found
SP2-0750: You may need to set ORACLE_HOME to your Oracle software directory
[oracle@d93334d5ada7 bin]$ /home/oracle/app/oracle/product/11.2.0/dbhome_2/bin/sqlplus / as sysdba
Error 6 initializing SQL*Plus
SP2-0667: Message file sp1<lang>.msb not found
SP2-0750: You may need to set ORACLE_HOME to your Oracle software directory
[oracle@d93334d5ada7 bin]$ echo $ORACLE_HOME
/home/oracle/app/oracle/product/11.2.0/dbhome_2/bin
[oracle@d93334d5ada7 bin]$ source /home/oracle/.bash_profile
[oracle@d93334d5ada7 bin]$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.1.0 Production on Fri May 27 09:24:20 2022

Copyright (c) 1982, 2009, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> SELECT name,log_mode FROM v$database;

NAME      LOG_MODE
--------- ------------
HELOWIN   NOARCHIVELOG

SQL> alter database archivelog;
alter database archivelog
*
ERROR at line 1:
ORA-01126: database must be mounted in this instance and not open in any
instance


SQL> SHUTDOWN IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> STARTUP MOUNT;
ORACLE instance started.

Total System Global Area 1603411968 bytes
Fixed Size                  2213776 bytes
Variable Size            1006635120 bytes
Database Buffers          587202560 bytes
Redo Buffers                7360512 bytes
Database mounted.
SQL> ALTER DATABASE ARCHIVELOG;

Database altered.

SQL> ALTER DATABASE OPEN;

Database altered.

SQL> SELECT name,log_mode FROM v$database;

NAME      LOG_MODE
--------- ------------
HELOWIN   ARCHIVELOG
```