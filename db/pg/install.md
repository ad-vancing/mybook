docker pull postgres:11.16

docker run --name pg2 -itd -p 5432:5432 -e POSTGRES_PASSWORD=mikeops postgres:11.16

docker exec -it pg psql -U postgres -d postgres


数据库相关概念：
https://zhuanlan.zhihu.com/p/357304812

PostgreSQL由一系列数据库组成。一套PostgreSQL程序称之为一个数据库群集。
当initdb()命令执行后，template0 , template1 , 和postgres数据库被创建。
template0和template1数据库是创建用户数据库时使用的模版数据库，他们包含系统元数据表。
initdb()刚完成后，template0和template1数据库中的表是一样的。但是template1数据库可以根据用户需要创建对象。
用户数据库是通过克隆template1数据库来创建的；


postgres=# show logging_collector;
 logging_collector
-------------------
 off
(1 row)

postgres=# alter system set logging_collector='on';
ALTER SYSTEM
postgres=# show logging_collector;
 logging_collector
-------------------
 off
(1 row)

service postgresql restart

sudo service postgresql restart

systemctl  restart  postgresql-10


service --status-all列出正在运行的服务

-- 查看配置文件位置,config_file对应的就是配置文件位置
select name,setting from pg_settings where category='File Locations';
/var/lib/postgresql/data/postgresql.conf
docker run --name pg1 --rm -itd -p 5432:5432 -e POSTGRES_PASSWORD=mikeops -v $PWD/pp.conf:/var/lib/postgresql/data/postgresql.conf postgres:11.16

```
listen_addresses = '*'
shared_buffers = 128MB
dynamic_shared_memory_type = posix
wal_level = logical
max_wal_size = 1GB
min_wal_size = 80MB
max_wal_senders = 8
wal_keep_segments = 4
max_replication_slots = 4
```

