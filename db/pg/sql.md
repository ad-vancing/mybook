https://www.tutorialspoint.com/postgresql/postgresql_create_database.htm

CREATE TABLE station (
  "id" int8 NOT NULL,
  "routecode" varchar ,
  "description" varchar(255) ,
  CONSTRAINT "station_pkey" PRIMARY KEY ("id")
)
select now();
show timezone;
set time zone 'PRC';
https://blog.csdn.net/lingyiwin/article/details/107243980
select * from pg_timezone_names where utc_offset = '08:00:00';
select now() at time zone 'Asia/Shanghai';
select now() at time zone 'UTC';