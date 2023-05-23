https://www.cnblogs.com/cashew/p/10722116.html

准确滴说，ip 是分配给每个网络硬件的，如果一台设备有多个网络硬件，那么就会有多个 ip 地址。

实际上，浏览器发送请求消息给服务器，是浏览器委托操作系统发送给web服务器（网络环境中）的。  
第一步需要查询网址中服务器域名对应的IP地址。

# TCP/IP结构
![](https://cdn.jsdelivr.net/gh/ad-vancing/pics/2023/202305232211568.png)

# ip协议头部
```
struct iphdr {
    unsigned char       ver_and_hdrlen;// 版本号与IP头部长度
    unsigned char       tos;           // 服务类型
    unsigned short      total_len;     // 总长度
    unsigned short      id;            // IP包ID
    unsigned short      flags;         // 标志位(包括分片偏移量)
    unsigned char       ttl;           // 生命周期
    unsigned char       protocol;      // 上层协议
    unsigned short      checksum;      // 校验和
    unsigned int        srcaddr;       // 源IP地址
    unsigned int        dstaddr;       // 目标IP地址
};
```