https://gitee.com/jiongmefeishi/JMFS-Interview-Notebook-Kubernetes

 kubectl top pod -n spark

kubectl logs -f -ntest data-dev-bench-glghh-f48bc669d-h4ch7

kubectl get cm -n spark|grep datax-1|awk '{print $1}'|xargs kubectl delete cm -n spark

kubectl get job -n spark | grep datax | awk '{print $1}' | xargs kubectl delete -n spark job

https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
kubectl get job -nspark -o custom-columns=CREATE:.metadata.creationTimestamp,name:.metadata.labels.job-name,states:.status.conditions[0].type | grep Complete| awk '{print $2}' | xargs kubectl delete -n spark job


[api doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#list-configmap-v1-core)


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