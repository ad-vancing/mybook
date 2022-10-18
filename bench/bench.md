设置Oracle LogMiner所需的配置
[root@tDataAnalysis01 config]# su - oracle
[oracle@tDataAnalysis01 config]$ sqlplus / as sysdba
alter system set db_recovery_file_dest_size = 10G;
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

SELECT dp.project_name, dt.name , dtn.node_name, dtn.id
from  data_task_node dtn
LEFT JOIN data_task dt ON dt.id = dtn.task_id
LEFT JOIN data_project dp ON dt.project_id = dp.project_id
WHERE dtn.id = 1273



                    nodeSelector:
        kubernetes.io/hostname: 21v-tc-sunyy-team-5