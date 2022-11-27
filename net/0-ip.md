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