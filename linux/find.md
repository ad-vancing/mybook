查找文件
find / -name filename.txt 根据名称查找/目录下的filename.txt文件。

find . -name "*.xml" 递归查找所有的xml文件

find .  -name "*.xml" |xargs grep  "hello world" 递归查找所有文件内容中包含hello world的xml文件

grep -H  'spring' *.xml 查找所以有的包含spring的xml文件

find ./ -size 0 | xargs rm -f & 删除文件大小为零的文件

ls -l | grep 'jar' 查找当前目录中的所有jar文件

grep 'test' d* 显示所有以d开头的文件中包含test的行。

grep 'test' aa bb cc 显示在aa，bb，cc文件中匹配test的行。

grep '[a-z]\{5\}' aa 显示所有包含每个字符串至少有5个连续小写字符的字符串的行。


查看端口占用情况
netstat -tln | grep 8080 查看端口8080的使用情况

21.查看端口属于哪个程序
lsof -i :8080

22.查看进程
ps aux|grep java 查看java进程

ps aux 查看所有进程


 audit 加上 file system watch

https://explainshell.com/


[Centos7系统tmp目录下文件默认保留时长](http://t.zoukankan.com/qiumingcheng-p-13419016.html)