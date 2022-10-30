[k8s中文文档](http://docs.kubernetes.org.cn/693.html)

[k8s](https://www.cnblogs.com/xzkzzz/p/9889173.html)

https://gitee.com/jiongmefeishi/JMFS-Interview-Notebook-Kubernetes

kubectl top pod -n spark

kubectl logs -f -ntest data-dev-bench-glghh-f48bc669d-h4ch7

kubectl get cm -n spark|grep datax-1|awk '{print $1}'|xargs kubectl delete cm -n spark

kubectl get job -n spark | grep datax | awk '{print $1}' | xargs kubectl delete -n spark job

https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
kubectl get job -nspark -o custom-columns=CREATE:.metadata.creationTimestamp,name:.metadata.labels.job-name,states:.status.conditions[0].type | grep Complete| awk '{print $2}' | xargs kubectl delete -n spark job


[api doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#list-configmap-v1-core)

# configmap
yaml中如果要输入大块有格式的数据可以用   ‘|-’，这样就会保留原有格式

在YAML中可以使用 '!!str' 将内容强制为字符类型，'!!int'将内容强制转换为整数类型

使用ConfigMap的限制条件!  
ConfigMap受Namespace限制，只有和cm处于相同Namespace下的才可以引用它

# pod
Pod的产生过程：配置完deployment的yaml文件之后:

1、通过kubectl create 创建一个deployment，那么此时就会调用deployment-controller（deployment控制器）创建一个replica set

2、replica set调用replicaset-controller创建pod

3、Pod创建完之后就会由启用资源调度程序default-scheduler，将pod分配对应的node节点，由kubelet管理pod


[设置kubectl命令的默认namespace](https://www.cnblogs.com/varyuan/p/14233142.html)


# job
https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/job/
## Job重启与失败认定
### 重启策略（restartPolicy）
Never：pod启动失败时不会重启，而是通过job-controller重新创建pod供节点调度。
OnFailure：pod将会在节点重启执行任务。

### 失败回退策略（backoffLimit）
当Job pod 经过多次重启无果，显然我们应该认定这个Job是一个失败任务，默认失败认定重启次数为6，我们可以通过在spec中添加backoffLimit来改变这一认定。
0

## Job 期限与清理
除了Job执行结束与重启失败认定的Job 终止外还可以通过配置活跃期限（activeDeadlineSeconds）来自动停止Job任务。
我们可以为 Job 的 .spec.activeDeadlineSeconds 设置一个秒数值。 该值适用于 Job 的整个生命期，无论 Job 创建了多少个 Pod。 一旦 Job 运行时间达到 activeDeadlineSeconds 秒，其所有运行中的 Pod 都会被终止，并且 Job 的状态更新为 type: Failed 及 reason: DeadlineExceeded。
优先级高于其 .spec.backoffLimit 设置。 因此，如果一个 Job 正在重试一个或多个失效的 Pod，该 Job 一旦到达 activeDeadlineSeconds 所设的时限即不再部署额外的 Pod，即使其重试次数还未 达到 backoffLimit 所设的限制。

清理job和终止相似，我们可以通过添加spec.ttlSecondsAfterFinished使Job在任务完成后一段时间内被清理。

## 并行 Job
### 指定任务数的并行 Job
通过spec.completions指定任务数，一旦所有 Pod 成功完成它的任务. 作业将完成。
Pod 创建存在先后顺序，即需要等待一个job完成后，开启下一个Job的运行。

### 工作队列式的并行 Job
parallelism 一旦一个 Pod 成功终止则所有 Pod 都都终止，此时Job 成功完成。
此类Job Pod在同一时间创建和结束。

# Cronjob
cronjob可以自动清理任务，默认保留3次成功的任务，我们可以通过添加.spec.successfulJobsHistoryLimit改变保留的历史任务信息即Pod。

# 网络模式
[pod的4种网络模式最佳实战(externalIPs )](https://blog.51cto.com/u_12182612/2478694)

[svc-externalIPs](https://www.cnblogs.com/jiangbo44/p/14772670.html)

```
  type: ClusterIP
  sessionAffinity: None
  externalTrafficPolicy: Cluster
```
这么写报错，除非type:NodePort
[externaltrafficpolicy一般是local模式或cluster模式](https://www.cnblogs.com/zisefeizhu/p/13262239.html)

# 授权策略
[PodSecurityPolicy](https://ieevee.com/tech/2019/02/18/psp.html#privileged)

1、创建psp
```
[root@master-02 ~]# kubectl get psp
NAME      PRIV    CAPS   SELINUX    RUNASUSER   FSGROUP    SUPGROUP   READONLYROOTFS   VOLUMES
default   false   *      RunAsAny   RunAsAny    RunAsAny   RunAsAny   false            secret,emptyDir,gitRepo,hostPath,configMap,downwardAPI,projected,persistentVolumeClaim
msa       false   *      RunAsAny   RunAsAny    RunAsAny   RunAsAny   false            secret,emptyDir,gitRepo,hostPath,configMap,downwardAPI,projected,persistentVolumeClaim
paas      false   *      RunAsAny   RunAsAny    RunAsAny   RunAsAny   false            secret,emptyDir,gitRepo,hostPath,configMap,downwardAPI,projected,persistentVolumeClaim
system    true    *      RunAsAny   RunAsAny    RunAsAny   RunAsAny   false            *

```
2、创建serviceaccount
```
[root@master-02 ~]# kubectl get sa
NAME      SECRETS   AGE
default   1         182d

```
3、绑定方法：创建Role，该Role可以use 该PodSecurityPolicy，然后用过创建的 rolebinding 将该role与用户或者serviceaccount绑定。
Role 和 ClusterRole 的区别是：
Role 有命名空间的限制，而 ClusterRole 可以跨命名空间，ClusterRoleBinding


# [POD持续terminating问题]()
1、看节点有木有坏  
2、后面加 --force

# alias
alias kubectl-admin='kubectl -n hellobaby'  
alias kubectl-user='kubectl --as=system:serviceaccount:hellobaby:fake-user -n hellobaby'

# 探针
```
    readinessProbe:
      exec:
        command:
        - /bin/sh
        - -c
        - MYSQL_PWD=${MYSQL_ROOT_PASSWORD}
        - mysql -h 127.0.0.1 -u root -e "SELECT 1"  -p${MYSQL_ROOT_PASSWORD}

```


```
    livenessProbe:
      exec:
        command:
        - /bin/sh
        - -c
        - mysqladmin ping -h 127.0.0.1 -u root -p${MYSQL_ROOT_PASSWORD}
      failureThreshold: 60
      initialDelaySeconds: 60
      periodSeconds: 10
      successThreshold: 1
      timeoutSeconds: 10

```