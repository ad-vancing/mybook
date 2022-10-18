[安装](https://zhuanlan.zhihu.com/p/443324194)
docker run -h "oracle" --name "oracle" -d -p 49160:22 -p 49161:1521 -p 49162:8080 oracleinanutshell/oracle-xe-11g
docker run -h "oracle" --name "oracle11" -d -p 1521:1521 registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g:latest

https://zhuanlan.zhihu.com/p/443324194
registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
find / oracle.* | grep oracle
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_2/bin
source /home/oracle/.bash_profile
sqlplus / as sysdba

conn oracle/oracle11;

conn / as sysdba

[时区相关](https://blog.csdn.net/Hohu_/article/details/88677118)
select sysdate from dual;
select dbtimezone from dual;
select sessiontimezone from dual;




查找数据库中没有唯一逻辑标识的表：
select owner, table_name
  from dba_logstdby_not_unique
 where (owner, table_name) not in
       (select distinct owner, table_name from dba_logstdby_unsupported)
   and bad_column = 'Y';

[oracle 服务名、实例名](https://www.jianshu.com/p/dd3f3144133c)

创建表空间、用户
```
CREATE TABLESPACE logminer_tbs DATAFILE 'logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
create tablespace cyan datafile './cyan.dbf' size 500M autoextend on; 

create user oracle identified by oracle11 default tablespace cyan;

grant all privileges to oracle;

select username,default_tablespace from dba_users;
```



[一些管理sql](https://www.cnblogs.com/R0ser1/p/15387539.html)

切库：
alter SESSION SET current_schema = MIKE