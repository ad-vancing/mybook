tree -L 2 hadoop/

查看所有端口被占用情况
netstat -a -t --numeric-ports -p
docker-compose ps
docker-compose exec hive-server bash
docker-compose -f  docker-compose.yml stop
hadoop dfsadmin -report
hadoop namenode -format