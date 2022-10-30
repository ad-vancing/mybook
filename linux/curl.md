https://linux.cmsblogs.cn/hot.html

https://curl.se/docs/httpscripting.html
直接在curl命令后加上网址，就可以看到网页源码。
$ curl http://www.baidu.com

# 参数
-k 跳过https

使用 -v 显示一次 http 通信的整个过程，包括端口连接和 http request 头信息
$ curl -v http://www.baidu.com

-X/--request <command>          指定什么命令
-F/--form <name=content>        模拟http表单提交数据
-H/--header <line>              自定义头信息传递给服务器，$ curl -H "Content-Type:application/json" http://example.com
-L参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向。
POST 方法必须把数据和网址分开，curl 就要用到 --data  或者 -d 参数
$ curl -X POST --data "data=xxx" http://example.com/form.cgi
如果你的数据没有经过表单编码，还可以让 curl 编码，参数是 --data-urlencode
$ curl -X POST --data-urlencode "date=April 1" http://example.com/form.cgi
使用 -X 使用其他的 HTTP 动词（默认 GET， 或者 -G）
$ curl -X DELETE http://www.example.com
—request 和 -X 指定与HTTP服务器通信时可以使用的自定义请求方法，将使用指定的请求方法代替其他方法（默认为GET）


使用 -o 参数将页面源码保存到本地
$ curl -o [文件名] http://www.baidu.com
curl https://s3.amazonaws.com/noaa.water-database/NOAA_data.txt -o NOAA_data.txt

添加 -i 或 --include 参数查看访问页面
$ curl -i http://www.baidu.com
添加 -i 参数后，页面响应头会和页面源码（响应体）一块返回。如果只想查看响应头，可以使用 -I 或 --head 参数。

文件上传
使用 -T 或者 --upload-file 参数
$ curl -T ./index.html http://www.uploadhttp.com/receive.cgi

-u参数用来设置服务器认证的用户名和密码。
$ curl -u 'bob:12345' https://google.com/login

Coocie
通过 --cookie 参数指定发送请求时的 Cookie 值，或通过 -b [文件名] 指定一个存储了 Cookie 值的本地文件
$ curl -b stored_cookies_in_file http://www.baidu.com
通过 -c 参数指定存储服务器返回 Cookie 值的存储文件
$ curl -b cookies.txt -c newcookies.txt http://www.baidu.com


  curl -s -v -H "Frank: xxx" -- "https://www.baidu.com"
请求的内容为：

  GET / HTTP/1.1
  Host: www.baidu.com
  User-Agent: curl/7.54.0
  Accept: */*
  Frank: xxx
添加 -X POST 参数：

  curl -X POST -s -v -H "Frank: xxx" -- "https://www.baidu.com"
请求的内容为：

  POST / HTTP/1.1
  Host: www.baidu.com
  User-Agent: curl/7.54.0
  Accept: */*
  Frank: xxx
添加 -d “1234567890” 参数：

  curl -X POST -d "1234567890" -s -v -H "Frank: xxx" -- "https://www.baidu.com"
请求的内容为：

  POST / HTTP/1.1
  Host: www.baidu.com
  User-Agent: curl/7.54.0
  Accept: */*
  Frank: xxx
  Content-Length: 10
  Content-Type: application/x-www-form-urlencoded
  ​
  1234567890
客户端发送一个 HTTP 请求到服务器的请求消息包括以下内容：



curl -X POS' http://localhost:8080/sp/aa-file -H accept: */* -H Content-Type: application/json -d '{h:hhhfile1={kk:ooo}}'



[参考1](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)
[参考2](https://www.cnblogs.com/duhuo/p/5695256.html)


## GET
`curl http://192.168.3.126:28503/api/v1/data-service/subject/sql-datas?subjectId=1`

`curl -G -d 'subjectId=1' -d 'count=20' http://192.168.3.126:28503/api/v1/data-service/subject/sql-datas`
参数写前面

`$ curl -d '{"login": "emma", "pass": "123"}' -H 'Content-Type: application/json' https://google.com/`

`curl -X GET "http://192.168.3.126:28503/api/v1/data-service/subject/sql-datas?subjectId=1" -H "accept: */*" -H "Authorization: dddd" -H "username: ddd"`

`curl https://192.168.3.126/api/v1/data-service/subject/sql-datas?subjectId=1 -H accept: */* -H Authorization:dddd -H username:ddd33`(有点问题)

可以""或''

## POST
`curl -X POST "http://192.168.3.126:28503/api/v1/data-service/deduce/upload?subjectId=1" -H "accept: */*" -H "Content-Type: multipart/form-data" -F "file=QQQ"`

`curl -X POST "http://192.168.3.126:28503/api/v1/data-service/dataDev/upload?fileName=jk.jar&jobId=2&spaceId=1&streamId=2" -H "accept: */*" -H "username: did" -H "Content-Type: multipart/form-data" -F "uploadFile=@hive-jar.rar;type=application/x-rar"`

`curl -X POST "http://192.168.3.126:28503/api/v1/data-service/dataDev/upload?fileName=jk.jar&jobId=2&spaceId=1&streamId=2" -H "accept: */*" -H "username: did" -H "Content-Type: multipart/form-data" -F "uploadFile=@demo.xlsx;type=application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"`

`curl -X POST "http://192.168.3.126:28503/api/v1/data-service/dataDev/upload?fileName=jk.jar&jobId=2&spaceId=1&streamId=2" -H "accept: */*" -H "username: did" -H "Content-Type: multipart/form-data" -F "uploadFile=@./mytest.txt"`



curl -L -X POST 'http://192.168.0.40:28503/api/v1/data-service/deduce/upload' --form 'type=1&subjectId=1' --form 'file=@/Users/guanliyuan/Desktop/XXL-JOB.postman_collection.json'


保存http的response里面的cookie信息。内置option:-c（小写）
`# curl -c cookiec.txt  http://www.linux.com`

`# curl -c cookie.txt -i "http://localhost:32001/users/sign_in" -s >token.txt`
[使用例子](https://blog.csdn.net/liumiaocn/article/details/107455737)
使用保存的cookie信息。内置option: -b
`# curl -b cookiec.txt http://www.linux.com`

保存http的response里面的header信息。内置option: -D
`# curl -D cookied.txt http://www.linux.com`

## 利用curl下载文件。
使用内置option：-o(小写)
`curl -o dodo1.jpg http:www.linux.com/dodo1.JPG`
使用内置option：-O（大写)
`curl -O http://www.linux.com/dodo1.JPG`