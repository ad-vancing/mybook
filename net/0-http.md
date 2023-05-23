
# osi 7层
国际标准化组织ISO制订的OSI参考模型提出了网络分层的思想  
- 物理层，负责在物理⽹络中传输数据帧，协议有：EIA/TIA RS-232、EIA/TIA RS-449、V.35、RJ-45等；  
- 数据链路层，负责数据的封帧和差错检测，以及 MAC 寻址，协议有：ARP、RARP、 HDLC、PPP、IEEE 802.3/802.2等；  
- ⽹络层，定义IP编址，定义路由功能，负责数据的路由、转发、分⽚，协议有： IP（IPV4 IPV6）、IPX、ICMP、IGMP、AppleTalk DDP等 ；  
- 传输层，负责端到端的数据包传输，协议有：TCP UDP SPX，数据包一旦离开网卡即进入网络传输层； 
- 会话层，负责建⽴、管理和终⽌表示层实体之间的通信会话和验证，如登入、断点续传，TLS、SSL、NetBIOS、RPC、NFS、AppleTalk等； 
- 表示层，负责把数据转换成兼容另⼀个系统能识别的格式，数据加解密，图片编码解码，ASCII、GIF、JPEG、MPEG等；
- 应⽤层，负责给应⽤程序提供统⼀的接⼝，协议有：HTTP FTP TFTP SMTP SNMP DNS TELNET HTTPS POP3 DHCP等。  
[参考](https://www.jianshu.com/p/9b9438dff7a2)  
[其他参考](https://www.cnblogs.com/cashew/p/10722116.html)  
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305232218161.png)

# 输入一个网址会发生什么
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305232216242.png)
1. DNS 解析：浏览器查询 DNS，获取域名对应的 IP 地址。  
2. TCP 连接：浏览器获得域名对应的 IP 地址以后，浏览器向服务器请求建立链接，发起三次握手；
3. 发送 HTTP 请求：TCP 连接建立起来后，浏览器向服务器发送 HTTP 请求；(该请求报文作为 TCP 三次握手的第三个报文的数据发送给服务器)
4. 服务器处理请求并返回 HTTP 报文：服务器接收到这个请求，并根据路径参数映射到特定的请求处理器进行处理，并将处理结果及相应的视图返回给浏览器；
5. 浏览器解析渲染页面：浏览器解析并渲染视图，若遇到对 js 文件、css 文件及图片等静态资源的引用，则重复上述步骤并向服务器请求这些资源；浏览器根据其请求到的资源、数据渲染页面，最终向用户呈现一个完整的页面。
6. 连接结束。

## 更多细节
-  浏览器数据封包(报文header、body)    
   TPC/IP协议是传输层协议，主要解决数据如何在网络中传输，而HTTP是应用层协议，主要解决如何包装数据。  
   把IP想像成一种高速公路，它允许其它协议在上面行驶并找到到其它电脑的出口。TCP和UDP是高速公路上的“卡车”，它们携带的货物就是像HTTP，文件传输协议FTP这样的协议等。 
-  浏览器查找域名的IP地址过程
- tcp 三次握手  
  TCP是一个端到端的可靠的面向连接的**传输层**协议，所以HTTP基于传输层TCP协议不用担心数据的传输的各种问题。  
  如果走 https 还需要**会话层** TLS、SSL 等协议。

-  HTTP请求   
   - 数据交换主要通过应用层 http 协议， post、get 请求， RESTFul 接口设计；  
   - 返回的信息是否需要缓存，以及客户端是否发送cookie等。
   
- 网络模型层面其他各层发生了什么   
  - 网络层 IP 协议、路由协议        
  通信双方不在一个局域网时，需要路由转发。   
  - 数据链路程  
   Address Resolution Protocol，地址解析协议，完成 IP 和 Mac 地址互解析
  - 物理层  
  层层封装后,数据比特流转成高低电频经过物理层发送到目标机器 

- server 处理流程  
server 这边 Nginx 拿到请求，进行一些验证，比如黑名单拦截、判断爬虫之类的；  
然后 Nginx 直接处理静态资源请求，其他请求 Nginx 转发给后端服务器；  
  >tomcat    
uWSGI, 他们之间通过 uwsgi 协议通讯，uWSGI 拿到请求，可以进行一些逻辑， 验证黑名单、等，根据 wsgi 标准，把拿到的 environs 参数扔给 Django ，Django 根据 wsgi 标准接收请求和 env， 然后开始 start_response ，先跑 Django 相关后台逻辑，Django 拿到请求执行 request middleware 内的相关逻辑，然后路由到相应 view 执行逻辑，出错执行 exception middleware 相关逻辑，接着 response 前执行 response middleware 逻辑，最后通过 wsgi 标准构造 response， 拿到需要返回的东西，设置一些 headers，或者 cookies 之类的，最后 finish_response 返回，再通过 uWSGI 给 Nginx ，Nginx 返回给浏览器。)

-  client 浏览器响应、渲染  
响应报文、[状态码](https://www.cnblogs.com/xiaobingzi/p/10748365.html)，什么时候重定向


# DNS 的解析过程
主机向本地域名服务器的查询一般都是采用递归查询。  
本地域名服务器向根域名服务器的查询的迭代查询。

    - 浏览器缓存 ：浏览器会缓存DNS记录一段时间。 有趣的是，操作系统没有告诉浏览器储存DNS记录的时间，这样不同浏览器会储存个自固定的一个时间（2分钟到30分钟不等）。
    - 系统缓存 ：如果在浏览器缓存里没有找到需要的记录，浏览器会做一个系统调用（windows里是gethostbyname）。这样便可获得系统缓存中的记录。读取系统hosts文件，查找其中是否有对应的ip。  
    - 路由器缓存 ：接着，前面的查询请求发向路由器，它一般会有自己的DNS缓存。
    - ISP DNS 缓存 ：接下来要check的就是ISP缓存DNS的服务器。在这一般都能找到相应的缓存记录。
    - 递归搜索 ：你的ISP的DNS服务器从根域名服务器（本地配置的首选DNS服务器）开始进行递归搜索、逐级访问，从.com顶级域名服务器到Facebook的域名服务器。（一般DNS服务器的缓存中会有.com域名服务器中的域名，所以到顶级服务器的匹配过程不是那么必要了）。

![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305232215828.png)

# HTTPS
##  HTTPS 和 HTTP 的区别
Http协议运行在TCP之上明文传输，客户端与服务器端都无法验证对方的身份；  
Https是身披SSL(Secure Socket Layer，比较老)或 TLS(Transport Layer Security) 外壳的Http，是添加了加密和认证机制的HTTP。  

- 安全性：HTTP 无状态的；HTTPS 协议是可加密传输、身份认证的网络协议，比 HTTP 协议安全
- 端口不同：80，443；
- 资源消耗：和HTTP通信相比，Https通信会由于加减密处理消耗更多的CPU和内存资源；
- 开销：Https通信需要证书，而证书一般需要向认证机构购买；  
  
HTTP只需要创建一次TCP连接，而HTTPS需要创建两次TCP连接
 

## 加密算法依赖
- 非对称加密耗时，对称加密不够安全，结合使用。
   - 非对称加密算法用于在握手过程中加密生成的密码，协商对称密钥，
   - 对称加密算法用于对真正传输的数据进行加密，
- HASH算法生成摘要，用于验证数据的完整性。

### 公钥与私钥
公钥只能用于加密数据，因此可以随意传输，而网站的私钥用于对数据进行解密，所以网站都会非常小心的保管自己的私钥，防止泄漏。

### 数字签名防篡改
保证在传输过程中不被篡改！  
把内容生成一份“签名”，比内容和签名是否一致就能判别是否被篡改。  
这就是数字证书的“防伪技术”，这里的“签名”就叫数字签名：
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305211903089.png)
[english artical](https://cheapsslsecurity.com/blog/digital-signature-vs-digital-certificate-the-difference-explained/)

## HTTPS 过程 
[HTTPS 之 SSL/TLS 握手协议（Handshake Protocol）全过程解析](https://www.jianshu.com/p/07a1e362e1ba)

[参考](https://www.17coding.info/article/22)

![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305212146016.png)

HTTPS在传输数据之前需要客户端（浏览器）与服务端（网站 server）之间进行一次握手，在握手过程中将确立双方加密传输数据的密码信息。
1. 浏览器将自己支持的一套加密规则、支持的加密方法列表、随机数Random_C等发送给 server。
2. server 从中选出一组加密算法与HASH算法，并将自己的身份信息以证书的形式发回给浏览器。**证书里面包含了网站地址，随机数 Random_S，加密公钥A，证书摘要**，以及证书的颁发机构等信息。
3. 获得网站证书之后浏览器要做以下工作：  
   - 验证证书的合法性（颁发证书的机构是否合法，证书中包含的网站地址是否与正在访问的地址一致，对数字签名验证等），如果证书受信任，则浏览器栏里面会显示一个小锁头，否则会给出证书不受信的提示。
   - 如果证书受信任，或者是用户接受了不受信的证书，**浏览器会又生成随机数 Random_pre-master，计算得到协商出的会话密钥（session key）**，此外用证书公钥加密该随机数 client_key_exchange。（服务器认证完成）
   - 使用约定好的 HASH 计算握手消息，并使用会话密钥加密，都发送给网站。
4. server 接收浏览器发来的数据之后要做以下的操作：
   - 使用自己的**私钥解密得到 Random_pre-master ，用商定好的加密算法进行对称加密，进而得到对话密钥（session key）**。
   - 解密客户端发送的 encrypted_handshake_message，验证数据和密钥正确性， HASH 是否与浏览器发来的一致
   - 使用对话密钥加密一段握手消息，发送给浏览器。
5. 浏览器解密并计算握手消息的 HASH，如果与服务端发来的 HASH 一致，此时握手过程结束。  
**之后所有的通信数据将由之前浏览器生成的对话密钥利用对称加密算法进行加密**。
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305240018332.png)

服务方S向第三方机构CA提交公钥、组织信息、个人信息(域名)等信息并申请认证;  
商业网站，证书要在权威机构购买如 keystroe、truststore

Charles 抓包原理？
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305232348116.png)
简单来说，就是Charles作为“中间人代理”，拿到了 服务器证书公钥 和 HTTPS连接的对称密钥，前提是客户端选择信任并安装Charles的CA证书，否则客户端就会“报警”并中止连接。

### 为什么需要hash一次？  
证书信息一般较长，比较耗时。而hash后得到的是固定长度的信息

# GET请求中URL编码的意义
解决参数值中包含 = 或 & 这种特殊字符的时候，对参数进行URL编码后，服务端会把紧跟在“%”后的字节当成普通的字节，就不会把它当成各个参数或键值对的分隔符了。


# HTTP 更新
- HTTP/1.0  
浏览器与服务器只保持短暂的连接，连接无法复用。  
每个TCP连接只能发送一个请求。发送数据完毕，连接就关闭，如果还要请求其他资源，就必须再新建一个连接。

  好像我们打电话的时候，只能说一件事儿一样，说完之后就要挂断，想要说另外一件事儿的时候就要重新拨打电话。
我们知道TCP连接的建立需要三次握手，是很耗费时间的一个过程。所以，HTTP/1.0版本的性能比较差。

- HTTP/1.1  
  - **持久连接**，即TCP连接默认不关闭，可以被多个请求复用。     
    >若connection 模式为close，则服务器主动关闭TCP 连接，客户端被动关闭连接，释放TCP 连接;若connection 模式为keepalive，则该连接会保持一段时间，在该时间内可以继续接收请求;
  - 更多的缓存控制策略
  - 请求头引入了range头域，它允许只请求资源的某个部分，即返回码是206（Partial Content）
  - 新增了24个错误状态响应码，如409（Conflict）表示请求的资源与资源的当前状态发生冲突；410（Gone）表示服务器上的某个资源被永久性的删除。
  - **管道机制（pipelining）**，即在同一个TCP连接里面，客户端可以同时发送多个请求。这样就进一步改进了HTTP协议的效率。
  - 队头阻塞问题
  
- SPDY  
  - 多路复用（multiplexing）。通过多个请求stream共享一个tcp连接的方式
  - 请求优先级（request prioritization）
  - header压缩
  - 强制使用 HTTPS
  - 服务端推送： 提现缓存
  
- HTTP/2.0(基于SPDY)  
 
## HTTP 2.0 的优势 
- 二进制框架层编码  
   请求和响应被分成更小的包，能显著的提高传输的灵活性。
- 流优先级  
  不仅仅解决同一资源的竞态问题，也允许开发人员自定义请求的权重   




网络七层模型是一个标准，而非实现。  

# 网络五层模型
网络5层模型是由七层模型简化合并而来的一个实现的应用模型。

https://www.iamshuaidi.com/723.html

# IP地址的分类
IP地址根据网络号 的不同分为 5 种类型：A 类地址、B 类地址、C 类地址、D 类地址和 E 类地址。  
[其他参考](https://www.cnblogs.com/cashew/p/10722116.html) 

https://www.iamshuaidi.com/704.html


# ARP 协议的工作原理
IP 地址主要用来网络寻址用的，就是大致定位你在哪里，而 MAC 地址，则是身份的唯一象征，通过 MAC 来唯一确认这人是不是就是你，MAC 地址不具备寻址的功能。

网络层的 ARP 协议完成了 IP 地址与物理地址的映射。  

每台主机都会在自己的 ARP 缓冲区中建立一个 ARP 列表，以表示 IP 地址和 MAC 地址的对应关系。


# ping的原理
[参考](https://www.jianshu.com/p/14113212cd18)

用“ping”命令可以检查网络是否通畅或者网络连接速度，很好地分析和判定网络故障。   
利用网络上机器IP地址的唯一性，给目标IP地址发送一个数据包，通过对方回复的数据包来确定两台网络机器是否连接相通，时延是多少。   

PING命令是我们能够直接使用的命令，像HTTP、FTP，属于应用层。ping命令底层使用的是ICMP协议，ICMP报文封装在ip包里，所以ICMP属于**网络层**协议，它没有通过运输层的TCP或UDP。

Ping发送一个ICMP；接收端回应消息给目的地并报告是否收到所希望的ICMPecho （ICMP回声应答）。

##  ICMP 协议
Internet Control Message Protocol 互联网控制报文协议  
主要的功能包括：确认 IP 包是否成功送达目标地址、报告发送过程中 IP 包被废弃的原因和改善网络设置等。


# 预检请求
OPTIONS请求，用于向服务器请求权限信息。预检请求被成功响应后，才会发出真实请求，携带真实数据。

![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305061840544.png)

# 其他
[中国十大骨干网](https://mp.weixin.qq.com/s/oQiyZ7aZGDBnX7gMENG3rg)

《计算机网络 谢希仁版》