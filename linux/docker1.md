https://hub.docker.com/u/library

https://docs.docker.com/get-started/

# 运行镜像
https://www.runoob.com/docker/docker-run-command.html
docker run

    -i: 以交互模式运行容器，通常与 -t 同时使用；
    -t :为容器重新分配一个伪输入终端，通常与 -i 同时使用；
	-d：deamon，后台启动
	-p：port, 端口映射，宿主机端口:容器内端口；8083是influxdb的web管理工具端口，8086是influxdb的HTTP API端口
	-v $PWD/config.yml:/etc/influxdb2/config.yml -v 主机绝对路径:容器路径（这是具名挂载）
	-e 后面加配置参数	
	-w 设置运行的工作目录
	--net 后面接自定义的网络名
	--ip 自定义网络后，可以自定义ip，使得容器ip固定下来
	--expose：允许容器接受外部传入的数据
	--name：容器名称，此处为influxERP
	--volume $PWD:/var/lib/influxdb2
	--volumes-from 继承某个容器的挂载
	--rm 停止了就删干净
	--link用来链接2个容器，使得源容器1和接收容器2之间可以互相通信，并且接收容器可以获取源容器的一些数据，如源容器的环境变量。

	CTRl PQ 退出后不会停止容器
	influxdb：镜像名

# 删除镜像
```


docker rmi -f 镜像id
docker rmi -f $(docker images -aq) 删除所有镜像
docker ps -aq | xargs docker rmi -f 

docker images | grep data-dev-bench | awk '{print $3}'| xargs docker rmi
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")




docker ps | awk '{print $1}'|xargs docker inspect --format '{{ .NetworkSettings.IPAddress }}' | grep 你的ip

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-ID>

https://cloud.tencent.com/developer/article/1083220
ping -w 4 c5
创建一个新的容器 container4 ，并将其连接到网络 isolated_nw 。 另外，使用 --link标志链接到容器 container5
$ docker run --network=isolated_nw -itd --name=container4 --link container5:c5 busybox

当 container5被创建时， container4将能够将名称 c5 解析为 container5 的IP地址

使用遗留的link功能创建的容器之间的任何链接本质上都是静态的，并且通过别名强制绑定容器。 它无法容忍链接的容器重新启动。 用户自定义网络中的新链接功能支持容器之间的动态链接，并且允许链接容器中的重新启动和IP地址更改。

```