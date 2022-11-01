# eg1
每个字段用","分隔
```
create table if not exists
datatype_test1(id int,col1 decimal,col2 decimal(9,8)) 
row format delimited fields terminated by ',';
```

```
#txt中的内容
1,0.82,83.2
2,1.06,9.22
```

`load data local inpath '/Users/test1.txt' into table datatype_test1;`
在指令中LOCAL关键字用于指定数据从本地加载，如果去掉该关键字，默认从HDFS进行加载！

如果数据加载到分区表，则必须指定分区列。

# eg2
struct，array，以及map的不同元素之间用";"分割，同时定义了map的key和value之间用":"分割。
```
create table if not exists
datatype_test4(
  id int,
  info struct<name:string,weight:double>,
  score array<Int>,
  info_map map<string,string>) 
row format delimited fields terminated by ',' 
COLLECTION ITEMS TERMINATED BY ';' 
MAP KEYS TERMINATED BY ':';
```

```
1,文文;70,99;96;100,name:文文;country:china
2,毛毛;60,99;92;100,name:毛毛;country:koera
3,超超;65,99;96;100,name:超超;country:japan
```

`load data local inpath '/Users/test4.txt' into table datatype_test4;`

```

select 
  info.name as name,
  info.weight as weight,
  score[0] as math,
  score[1] as chinese,
  score[2] as English ,
  info_map['name'] as name,
  info_map['country'] as country
from 
  datatype_test4;
```

load data local inpath '/home/hadoop/student.txt' into table t3 partition(year=2014,month=11);

