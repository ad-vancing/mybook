#！/bin/bash

# 判断参数个数
if [$# -lt 1]
then
  echo Not Enough Arguement!
  exit;
fi

# 遍历集群所有机器 s1 s2 s2
for host in s1 s2 s2
do
  echo ==============$host ==============
  # 遍历所有目录，挨个发送
  for file in $@
  do
    #判断文件是否存在
    if [-e $file]
      then
        # 获取父目录
        pdir=$(cd -p $(dirname $file); pwd)
        # 获取当前文件名称
        fname=$(basename $file)
        ssh $host "mkdir -p $pdir"
        rsync -av $pdir/$fname $host:$pdir
      else
        echo $file does not exists!
    fi
  done
done