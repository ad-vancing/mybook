ORDER BY的是它仅在每个reducer进行排序，而不是全局排序，且不支持ASC和DESC。如果要实现全局排序，可以先进行CLUSTER BY然后再ORDER BY

动态分区默认是关闭的，可通过以下设置开启：SET hive.exec.dynamic.partition=true; 
Hive默认至少需要一个partition列是静态的，可以通过以下设置关闭：SET hive.exec.dynamic.partition.mode=nonstrict;


# 往分区插入数据
INSERT INTO TABLE employee_partitioned PARTITION(year,month) 
SELECT name,array('Toronto') AS work_place, named_struct("sex","Male","age",30) AS sex_age, map("Python",90) AS skills_score, map("R&D",array('Developer')) AS depart_title, year(start_date) AS year, month(start_date) AS month FROM employee_hr eh WHERE eh.employee_id = 102;


在一些Hadoop版本中目录深度只支持到2层，可以使用以下设置修复：SET hive.insert.into.multilevel.dirs=true; hive> INSERT OVERWRITE LOCAL DIRECTORY '/apps/ca' SELECT * FROM employee;