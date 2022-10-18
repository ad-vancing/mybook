# 输入一个网址，在浏览器中会发生什么 《图解HTTP》
1、浏览器数据封包
2、浏览器查找域名的IP地址（数据链路层解析 IP 与 mac 地址的映射）
DNS查找过程如下：
浏览器缓存 – 浏览器会缓存DNS记录一段时间。 有趣的是，操作系统没有告诉浏览器储存DNS记录的时间，这样不同浏览器会储存个自固定的一个时间（2分钟到30分钟不等）。
系统缓存 – 如果在浏览器缓存里没有找到需要的记录，浏览器会做一个系统调用（windows里是gethostbyname）。这样便可获得系统缓存中的记录。
路由器缓存 – 接着，前面的查询请求发向路由器，它一般会有自己的DNS缓存。
ISP DNS 缓存 – 接下来要check的就是ISP缓存DNS的服务器。在这一般都能找到相应的缓存记录。
递归搜索 – 你的ISP的DNS服务器从跟域名服务器开始进行递归搜索，从.com顶级域名服务器到Facebook的域名服务器。一般DNS服务器的缓存中会有.com域名服务器中的域名，所以到顶级服务器的匹配过程不是那么必要了。

3、浏览器给web服务器发送一个HTTP请求 (网络层面～～)
数据交换主要通过 http 协议， http 协议是无状态协议，这里可以谈一谈 post、get 的区别以及 RESTFul 接口设计；
如果走 https 还需要会话层 TLS、SSL 等协议； 
client （浏览器）与 server 通过 http 协议通讯，http 协议属于应用层协议，http 基于 tcp 协议，tcp 属于传输层协议。
传输层 tcp 协议可以说下比较经典的三次握手、四次分手的过程和状态机

4、server 处理流程
server 这边 Nginx 拿到请求，进行一些验证，比如黑名单拦截之类的，
然后 Nginx 直接处理静态资源请求，其他请求 Nginx 转发给后端服务器，
tomcat

(这里我用 uWSGI, 他们之间通过 uwsgi 协议通讯，uWSGI 拿到请求，可以进行一些逻辑， 验证黑名单、判断爬虫等，根据 wsgi 标准，把拿到的 environs 参数扔给 Django ，Django 根据 wsgi 标准接收请求和 env， 然后开始 start_response ，先跑 Django 相关后台逻辑，Django 拿到请求执行 request middleware 内的相关逻辑，然后路由到相应 view 执行逻辑，出错执行 exception middleware 相关逻辑，接着 response 前执行 response middleware 逻辑，最后通过 wsgi 标准构造 response， 拿到需要返回的东西，设置一些 headers，或者 cookies 之类的，最后 finish_response 返回，再通过 uWSGI 给 Nginx ，Nginx 返回给浏览器。)

5、浏览器响应渲染

更好的：https://juejin.cn/post/6844903744644055054


![](https://segmentfault.com/img/remote/1460000008758387?w=875&h=976)
https://segmentfault.com/a/1190000008758381

## 精简版
在浏览器地址栏键入URL，按下回车之后会经历以下流程：

1、浏览器向DNS 服务器请求解析该 URL 中的域名所对应的 IP 地址;
2、解析出 IP 地址后，根据该 IP 地址和默认端口 80，和服务器建立 TCP 连接;
3、浏览器发出读取文件(URL 中域名后面部分对应的文件)的HTTP 请求，该请求报文作为 TCP 三次握手的第三个报文的数据发送给服务器;
4、服务器对浏览器请求作出响应，并把对应的 html 文本发送给浏览器;
5、释放 TCP 连接;
6、浏览器将该 html 文本并显示内容;


# HTTPS 是怎么加密的
非对称加密耗时，对称加密不够安全，结合。
非对称加密算法用于在握手过程中加密生成的密码，对称加密算法用于对真正传输的数据进行加密，而HASH算法用于验证数据的完整性。
公钥只能用于加密数据，因此可以随意传输，而网站的私钥用于对数据进行解密，所以网站都会非常小心的保管自己的私钥，防止泄漏。

HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议。
https://zhuanlan.zhihu.com/p/43789231

HTTPS在传输数据之前需要客户端（浏览器）与服务端（网站）之间进行一次握手，在握手过程中将确立双方加密传输数据的密码信息。
1.浏览器将自己支持的一套加密规则发送给网站。
2.网站从中选出一组加密算法与HASH算法，并将自己的身份信息以证书的形式发回给浏览器。证书里面包含了网站地址，加密公钥，以及证书的颁发机构等信息。
3.获得网站证书之后浏览器要做以下工作：
a) 验证证书的合法性（颁发证书的机构是否合法，证书中包含的网站地址是否与正在访问的地址一致等），如果证书受信任，则浏览器栏里面会显示一个小锁头，否则会给出证书不受信的提示。
b) 如果证书受信任，或者是用户接受了不受信的证书，浏览器会生成一串随机数的密码，并用证书中提供的公钥加密。
c) 使用约定好的HASH计算握手消息，并使用生成的随机数对消息进行加密，最后将之前生成的所有信息发送给网站。

4.网站接收浏览器发来的数据之后要做以下的操作：
a) 使用自己的私钥将信息解密取出密码，使用密码解密浏览器发来的握手消息，并验证HASH是否与浏览器发来的一致。
b) 使用密码加密一段握手消息，发送给浏览器。
5.浏览器解密并计算握手消息的HASH，如果与服务端发来的HASH一致，此时握手过程结束，之后所有的通信数据将由之前浏览器生成的随机密码并利用对称加密算法进行加密。

这里浏览器与网站互相发送加密的握手消息并验证，目的是为了保证双方都获得了一致的密码，并且可以正常的加密解密数据，为后续真正数据的传输做一次测试。



# HTTP1.1和2.0协议的区别
http2中 每个消息被划分为更小的帧单元。
与 http1.1把所有请求和响应作为纯文本不同，http2 使用二进制框架层把所有消息封装成二进制，且仍然保持http语法，消息的转换让http2能够尝试http1.1所不能的传输方式。
https://www.jianshu.com/p/63fe1bf5d445

[https://blog.csdn.net/ThinkWon/article/details/104397516](https://blog.csdn.net/ThinkWon/article/details/104397516)
一样的http://ifeve.com/spring-interview-questions-and-answers/
一样的https://zhuanlan.zhihu.com/p/115029344

[https://www.zhihu.com/question/39814046](https://www.zhihu.com/question/39814046)

[https://juejin.im/post/6844903860658503693](https://juejin.im/post/6844903860658503693)[https://juejin.im/post/6854573217013727246](https://juejin.im/post/6854573217013727246)[https://www.cnblogs.com/jingmoxukong/p/9408037.html](https://www.cnblogs.com/jingmoxukong/p/9408037.html)

[aop](https://my.oschina.net/spinachgit/blog/3013159)[Spring容器IOC初始化过程](https://www.javazhiyin.com/64744.html)




