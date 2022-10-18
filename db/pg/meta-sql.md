
# 版本
SELECT version();
PostgreSQL 11.13 on x86_64-apple-darwin, compiled by Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn), 64-bit

SELECT current_setting('server_version_num');

https://www.tutorialspoint.com/postgresql/postgresql_select_database.htm

# create and insert
CREATE TABLE "station" (
  "id" int8 NOT NULL,
  "routecode" varchar COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default"
);

INSERT INTO "public"."station"("id", "routecode", "description") VALUES (2, 'ops1', 'opsdesct');
INSERT INTO "public"."station"("id", "routecode", "description") VALUES (3, 'ops2', 'opsdescg');
INSERT INTO "public"."station"("id", "routecode", "description") VALUES (4, 'ops3', 'opsdescd');


1.查询当前数据库：
终端：\c
sql语句：select current_database();

2.查询数据库下有哪些 schema
SELECT schema_name from information_schema.schemata

3.查询 schema 下有哪些表
SELECT tablename,schemaname FROM pg_tables WHERE schemaname = 'roadschema'

4.查询表的字段名、字段类型
SELECT
	A.attname AS NAME,
	format_type(A.atttypid, A.atttypmod) AS TYPE,
	A.attnotnull AS NOTNULL,
	col_description(A.attrelid, A.attnum) AS COMMENT
FROM
	pg_class AS C,
	pg_attribute AS A 
WHERE
	C.relname = 'station' 
	AND A.attnum > 0
	AND A.attrelid = C.oid 
	
select a1.attname as column_name,t.typname as data_type,d.description as column_comment 
from (select a.attname,a.attrelid,a.atttypid,a.attnum from pg_attribute a,pg_class c where c.relname = 'station' and a.attnum>0 and a.attrelid=c.oid)a1 
left join pg_type t on a1.atttypid=t.oid 
left join pg_description d on d.objoid=a1.attrelid and d.objsubid=a1.attnum where t.typname is not null	

-- 区分了schema
select a.attname as column_name,t.typname as data_type, c.relnamespace, a.attrelid,a.atttypid,a.attnum from pg_attribute a
JOIN
(SELECT  relnamespace, oid from pg_class where relname = 'station') c  ON a.attrelid=c.oid
JOIN 
(SELECT nspname, oid from pg_namespace where nspname = 'public') pn ON pn.oid = c.relnamespace
left join pg_type t on a.atttypid=t.oid 
where a.attnum>0

类型
SELECT typname, oid FROM pg_type

系统视图
[系统表信息](https://www.cnblogs.com/orangeform/archive/2012/05/25/2305415.html)