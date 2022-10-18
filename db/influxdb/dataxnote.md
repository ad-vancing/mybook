# python bin/datax.py -r influxdbreader -w hdfswriter

> create user mike with password 'mikeops'  with all privileges;

{
    "job": {
        "setting": {
            "speed": {
                "channel": 3,
                "byte": 1048576
            },
            "errorLimit": {
                "record": 0,
                "percentage": 0.02
            }
        },
        "content": [
            {
                "reader": {
                    "name": "influxdbreader", 
                    "parameter": {
                        "querySql":"select time,\"level description\",location,water_level from h2o_feet", 
                        "connTimeout": 15, 
                        "connection": [
                            {
                                "database": "NOAA_water_database", 
                                "endpoint": "http://172.22.50.197:8086", 
                                "table": "h2o_feet", 
                                "where": "1=1"
                            }
                        ], 
                        "password": "mikeops", 
                        "readTimeout": 20, 
                        "username": "mike", 
                        "writeTimeout": 20
                    }
                },
                "writer": {
                    "name": "hdfswriter",
                    "parameter": {
                        "fileName": 1655435723618,
                        "defaultFS": "hdfs://hdfs-k8s",
                        "fileType": "ORC",
                        "path": "/user/hive/warehouse/data_sync.db/test_influx1",
                        "writeMode": "append",
                        "fieldDelimiter": "\u0001",
                        "column": [
                            {
                                "name": "ETL_time",
                                "type": "timestamp"
                            },
                                        {
                                "name": "level",
                                "type": "string"
                            },
                                        {
                                "name": "location",
                                "type": "string"
                            },
                                        {
                                "name": "wate_level",
                                "type": "decimal"
                            }
                        ],
                        "hadoopConfig": {
                            "fs.defaultFS": "hdfs://hdfs-k8s",
                            "dfs.ha.namenodes.hdfs-k8s": "nn0,nn1",
                            "dfs.namenode.rpc-address.hdfs-k8s.nn1": "hdfs-namenode-1.hdfs-namenode.system-bigdata.svc.cluster.local:9820",
                            "dfs.client.failover.proxy.provider.hdfs-k8s": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider",
                            "dfs.namenode.rpc-address.hdfs-k8s.nn0": "hdfs-namenode-0.hdfs-namenode.system-bigdata.svc.cluster.local:9820",
                            "dfs.nameservices": "hdfs-k8s"
                        }
                    }
                }
            }
        ]
    },
    "core": {
        "transport": {
            "channel": {
                "speed": {
                    "byte": 1231412
                }
            }
        }
    }
}