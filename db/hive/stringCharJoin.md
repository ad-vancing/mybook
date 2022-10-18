create table ads.ff1(
sid int,
sname string,
clsid bigint,
cc char(100),
ss varchar(100)
);

insert into ads.ff1 values (1,'a', 2, 'aa', 'aaa');

create table ads.ff2(
sid int,
sname string,
clsid bigint,
cc char(100),
ss varchar(100)
);

insert into ads.ff2 values (1,'a', 2, 'aa', 'aaa');
insert into ads.ff2 values (1,'a', 2, 'aaa', 'aa');
insert into ads.ff2 values (1,'a', 2, 'a', 'a');

use  ads;
select * from ff1  f1
left join ff2 f2 on f1.cc = f2.cc;

select * from ff1  f1
left join ff2 f2 on f1.ss = f2.ss;

select * from ff1  f1
left join ff2 f2 on f1.cc = f2.ss;

use  ads;
select * from ff1  f1
left join ff2 f2 on f1.sname = f2.cc;

use  ads;
select * from ff1  f1
left join ff2 f2 on f1.sname = f2.ss;


-----
create table ads.ffa1(
sid int,
sname string,
clsid bigint,
cc char(10),
ss varchar(100)
);

insert into ads.ffa1 values (1,'a', 2, 'aa', 'aaa');

create table ads.ffa2(
sid int,
sname string,
clsid bigint,
cc char(100),
ss varchar(100)
);

insert into ads.ffa2 values (1,'a', 2, 'aa', 'aaa');
insert into ads.ffa2 values (1,'a', 2, 'aaa', 'aa');
insert into ads.ffa2 values (1,'a', 2, 'a', 'a');

use  ads;
select * from ffa1  f1
left join ffa2 f2 on f1.cc = f2.cc;

select * from ffa1  f1
left join ffa2 f2 on f1.ss = f2.ss;

use  ads;
select * from ffa1  f1
left join ffa2 f2 on f1.cc = f2.ss;
-- hive on spark 执行 f2 无结果 char、varchar

use  ads;
select * from ffa1  f1
left join ffa2 f2 on f1.sname = f2.cc;
-- hive on spark 执行 f2 无结果 string、char

use  ads;
select * from ffa1  f1
left join ffa2 f2 on f1.sname = f2.ss;