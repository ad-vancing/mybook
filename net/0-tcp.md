https://plantegg.github.io/categories/TCP/

# TCP连接的过程
https://cloud.tencent.com/developer/article/1198221

1、客户端发送的TCP报文中标志位SYN置1，初始序号seq=x（随机选择）。Client进入SYN_SENT状态，等待Server确认。  
2、服务器收到数据包后，根据标志位SYN=1知道Client请求建立连接，Server将标志位SYN和ACK都置为1，ack=x+1，随机产生一个初始序号seq=y，并将该数据包发送给Client以确认连接请求，Server进入SYN_RCVD状态。  
3、Client收到确认后，检查ack是否为x+1，ACK是否为1，如果正确则将标志位ACK置为1，ack=y+1，并将该数据包发送给Server。Server检查ack是否为y+1，ACK是否为1，如果正确则连接建立成功，Client和Server进入ESTABLISHED状态，完成三次握手，随后Client与Server之间可以开始传输数据了。

![](https://ask.qcloudimg.com/http-save/yehe-1446775/uwl5mh9ogf.png?imageView2/2/w/1620)

## 四次挥手
1、Client发送一个FIN，用来关闭Client到Server的数据传送，Client进入FIN_WAIT_1状态。  
2、Server收到FIN后，发送一个ACK给Client，确认序号为u + 1（与SYN相同，一个FIN占用一个序号），Server进入CLOSE_WAIT状态。  
3、Server发送一个FIN，用来关闭Server到Client的数据传送，Server进入LAST_ACK状态。  
4、Client收到FIN后，Client进入TIME_WAIT状态(主动关闭方才会进入该状态），接着发送一个ACK给Server，确认序号为w + 1，Server进入CLOSED状态，完成四次挥手。

![](https://ask.qcloudimg.com/http-save/yehe-1446775/ok7sodrcza.png?imageView2/2/w/1620)

## 为什么要三次握手建立连接
TCP连接是可靠的双工通信，在连接建立阶段必须确认双向通信都是OK的。理论上来讲这需要至少四次交互：  
Client发送SYN  
Server响应ACK  
Server发送SYN  
Client响应ACK(如果没有这一步，Server无法知道Client能否收到自己的消息）1、2两步让Client知道自己和Server之间的双向通信是OK的，3、4两步让Server知道自己和Client之间的双向通信是OK的。 实际应用中，2、3两步合并了，所以最终就只有三次握手。

关闭连接时，服务端未必把全部数据都发给了对方，所以我们可以立即close，也可以发送一些数据给对方后，再发送FIN报文给对方表示同意关闭连接。
因此我们的ACK和FIN一般会分开发送。  

ACK—表明确认序号是有效的  
SYN—初始化连接的同步序号  
FIN—意味着发送端已经完成数据的传输

##  为什么 TIME_WAIT 状态需要经过 2MSL 才能返回到 CLOSE 状态
上面的链接

1、可靠的终止TCP连接 
2、保证让迟来的TCP报文段有足够的时间被识别并丢弃

1）为实现TCP这种全双工连接的可靠释放

这样可让TCP再次发送最后的ACK以防这个ACK丢失(另一端超时并重发最后的FIN)这种2MSL等待的另一个结果是这个TCP连接在2MSL等待期间，定义这个连接的插口(客户的IP地址和端口号，服务器的IP地址和端口号)不能再被使用。这个连接只能在2MSL结束后才能再被使用。

2）为使旧的数据包在网络因过期而消失

每个具体TCP实现必须选择一个报文段最大生存时间MSL。它是任何报文段被丢弃前在网络内的最长时间。


# TCP/IP协议、长连接与短连接等

# 一条TCP连接上可以发多少个HTTP请求
https://cloud.tencent.com/developer/article/1526057
如果维持连接的话，一个 TCP 连接是可以发送多个 HTTP 请求的。
HTTP/1.1 存在 Pipelining 技术可以完成这个多个请求同时发送，但是由于浏览器默认关闭，所以可以认为这是不可行的。

在 HTTP2 中由于 Multiplexing 特点的存在，多个 HTTP 请求可以在同一个 TCP 连接中并行进行。

那么在 HTTP/1.1 时代，浏览器是如何提高页面加载效率的呢？主要有下面两点：

维持和服务器已经建立的 TCP 连接，在同一连接上顺序处理多个请求。
和服务器建立多个 TCP 连接。


# UDP和TCP的区别
TCP协议是有连接的，有连接的意思是开始传输实际数据之前TCP的客户端和服务器端必须通过三次握手建立连接，会话结束之后也要结束连接。
而UDP是无连接的。  
TCP协议保证数据按序发送，按序到达，提供超时重传来保证可靠性，但是UDP不保证按序到达，甚至不保证到达，只是努力交付，即便是按序发送的序列，也不保证按序送到。  
TCP协议所需资源多，TCP首部需20个字节（不算可选项），UDP首部字段只需8个字节。  
TCP有流量控制和拥塞控制，UDP没有，网络拥堵不会影响发送端的发送速率  
TCP是一对一的连接，而UDP则可以支持一对一，多对多，一对多的通信。  
TCP面向的是字节流的服务，UDP面向的是报文的服务。


TCP协议是面向连接的，每个数据包的传输过程是：先建立链路、数据传输、然后清除链路。数据包不包含目的地址。受端和发端不但顺序一致，而且内容相同。它的可靠性高。

UDP协议是面向无连接的，每个数据包都有完整的源、目的地址及分组编号，各自在网络中独立传输，传输中不管其顺序，数据到达收端后再进行排序组装，遇有丢失、差错和失序等情况，通过请求重发来解决。它的效率比较高。

# TCP 的拥塞控制

#TCP 如何解决流控、乱序、丢包问题

# 为什么会出现粘包和拆包，如何解决
https://blog.csdn.net/v123411739/article/details/99708892
