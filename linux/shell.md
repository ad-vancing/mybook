# 基本的
到上一次所在的目录
cd -

# less命令
d  向后翻半页
u  向前滚动半页

b  向后翻一页
y  向前滚动一行


# [vi常用命令](https://www.cnblogs.com/cashew/p/10606028.html)

复制 yy
多行复制 nyy
粘贴 p

多行删除 ndd

显示行号 : set nu
跳转到某行 : 5

跳转到第一行开头 gg
跳转到最后一行开头 G
跳转到行头 0
跳转到行尾 $


[我以前总结的](https://segmentfault.com/a/1190000018923985)  
[linux调度功能crontab](https://www.cnblogs.com/cashew/p/10734212.html)  
[配置yum源](https://www.cnblogs.com/cashew/p/9350028.html)

  

# cat
cat -n 由 1 开始对所有输出的行数编号。

清空 /etc/test.txt 文档内容：
cat /dev/null > /etc/test.txt  
在类 Unix 系统中，/dev/null 称空设备，是一个特殊的设备文件，它丢弃一切写入其中的数据（但报告写入操作成功），读取它则会立即得到一个 EOF。

[ /dev/null 和 /dev/zero ](https://blog.csdn.net/longerzone/article/details/12948925)

# date
```
[admin@localhost]$ date -d@1323004944
2011年12月 04日 星期日21:22:24CST
[admin@localhost]$ date -d@1323004944 -u
2011年12月 04日 星期日13:22:24UTC 
```

# 网络相关
- ss 是 Socket Statistics 的缩写。  
ss 命令可以用来获取 socket 统计信息，它显示的内容和 netstat 类似。  
查看主机监听的端口`$ ss -tnl`


    