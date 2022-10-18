# 进程间通信的方式
https://cloud.tencent.com/developer/article/1690556

# 怎么查看进程的内存
https://www.cnblogs.com/wangmo/p/9486569.html
top命令默认是以CPU排序输出的，按字母「M」，可以按内存占用大小进行排序显示
VIRT：进程占用的虚拟内存
RES：进程占用的物理内存
SHR：进程使用的共享内存
%CPU：进程占用CPU的使用率
%MEM：进程使用的物理内存和总内存的百分比
TIME+：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。


# 线上CPU100%，如何定位和排查问题
用top命令来监控看是哪个进程占用最多，定位到出问题的线程，再打印线程堆栈查看运行情况

# 查看cpu和文件目录
cpu信息查看：lscpu
cpu使用情况查看, 5分钟，15分钟 cpu使用率 :w
内存查看：free -h
硬盘 df -h

# ulimit
`ulimit -n 1000000`每个进程可以打开的文件数目，缺省为1024。  
小了就“Too many open files”了。

[其他](https://www.cnblogs.com/zengkefu/p/5649407.html)
