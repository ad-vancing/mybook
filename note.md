面试无非就是考察计算机基础 + 算法 + 语言特性 + 项目。

常用框架原理  
中间件原理

不同公司重点是不同的，例如你面试腾讯的话，可能网络这块会问的多一些；面阿里时，可能 Java 会问的多一些；面字节时，可能算法会问的多一些。

# 防止数据重复提交
https://juejin.cn/post/6850418120985837575
总体思路：方法执行之前，先判断此业务是否已经执行过，如果执行过则不再执行，否则就正常执行。

实现1:将请求的业务 ID 存储在 HashMap 中缓存。
存在的问题：HashMap 是无限增长的，因此它会占用越来越多的内存，并且随着 HashMap 数量的增加查找的速度也会降低，所以我们需要实现一个可以自动“清除”过期数据的实现方案。

优化1.1:使用数组加下标计数器（reqCacheCounter）的方式，实现了固定数组的循环存储。当数组存储到最后一位时，将数组的存储下标设置 0，再从头开始存储数据。
优化1.2:使用单例中著名的 DCL（Double Checked Locking，双重检测锁）来优化代码的执行效率，适用于重复提交频繁比较高的业务场景，对于相反的业务场景下 DCL 并不适用。
优化1.3:Apache 为我们提供了一个 commons-collections 的框架，里面有一个非常好用的数据结构 LRUMap （ Least Recently Used ）可以保存指定数量的固定的数据，并且它会按照 LRU 算法，帮你清除最不常用的数据。

接口保证幂等性

# java

## mark

[OpenJDK和Oracle JDK有什么区别和联系](https://blog.csdn.net/bisal/article/details/104832084/)

>高版本的 JDK 能向下兼容以前版本的 Class 文件，但不能运行以后版
本的 Class 文件，即使文件格式并未发生任何变化，虚拟机也必须拒绝执行超过其版本号的 Class 文件。

[intellij_idea使用指南](https://www.w3cschool.cn/intellij_idea_doc/intellij_idea_doc-rif12e7d.html)

## tool
JHSDB 是一款基于服务性代理实现的进程外调试工具
athas


[想做这种gitbook](https://troywu0.gitbooks.io/spark/content/java%E5%AF%B9%E8%B1%A1%E5%88%9B%E5%BB%BA%E7%9A%84%E8%BF%87%E7%A8%8B.html)

一些问号：
抽象类ClassLoader中，loadClass(String name, boolean resolve)方法里使用了（锁对象的）同步代码快，被实现类重写后，就失效了？

ConcurrentHashMap<String, Object> parallelLockMap;在ClassLoader中是怎么使用的？


# 资料
[pdf资料](https://www.pdfdrive.com/)

[何苦呢？](https://blog.csdn.net/qq_35854212/article/details/103144496)
## git项目
[电商](https://github.com/macrozheng/mall)

https://github.com/fantasticmaker

funny project
https://gitee.com/ainilili/ratel

https://zh.wikipedia.org/wiki/AWK

[b站程序员](https://live.bilibili.com/21907556)

[idea easy code](https://blog.csdn.net/qq_38225558/article/details/84479653)

## 还行的技术博客
[并发编程](http://ifeve.com/java-threadpool/)

[并发编程2](https://www.cnblogs.com/corvey/p/8478801.html)

[并发编程3](https://www.cnblogs.com/waterystone/p/4920797.html)

[JUC](https://www.cnblogs.com/linkworld/p/7819270.html)

[nio](https://www.iteye.com/blog/zhangshixi-679959)

[mybatisplus](https://www.jianshu.com/p/07be9ccb3306)

[mybatis](https://www.cnblogs.com/yixiu868/category/944649.html)

[文件上传](https://www.cnblogs.com/yixiu868/p/6365937.html)

[shiro](https://www.cnblogs.com/xuxinstyle/p/9674816.html)

[个人博客1](https://blog.ljyngup.com/page/3/)

[个人博客2数据结构c](https://www.cnblogs.com/darkchii/p/9070175.html)

[git学习](https://git-scm.com/book/zh/v1/Git-%E5%9F%BA%E7%A1%80-%E6%89%93%E6%A0%87%E7%AD%BE)

有些东西，学到不一定能用到，但到你需要用到的时候再去学，很可能就来不及了。




# 刷题巩固
https://zhuanlan.zhihu.com/p/79224082

https://www.mianshi.online/

知识储备固然重要，但是精通才是更重要的，东西不再多在于精。

[linux发行版本](http://www.distrowatch.org/)

[github做Markdown图床](https://www.jianshu.com/p/33eeacac3344)

# md
[在线md](https://stackedit.io/app#)


## 综合
[java全](https://chanshiyu.gitbook.io/blog/hou-duan/java)
[java高级](https://blog.csdn.net/weixin_42213903/article/details/99114232)
[JUC源码](https://blog.csdn.net/weixin_41973131/category_9287477.html)
## 工具
[intellij-idea-tutorial](http://wiki.jikexueyuan.com/project/intellij-idea-tutorial/ubuntu-install.html)
[反编译工具](http://java-decompiler.github.io/)







# redis
[《Redis入门指南》](https://github.com/luin/redis-book-assets)
# http
[http请求](http://coolaf.com/)
# 刷题
[面试准备](https://github.com/CyC2018/CS-Notes)
[《吊打面试官》系列](https://www.cnblogs.com/aobing/p/11801118.html#4416994)
[java高并发常见问题](http://www.yayihouse.com/yayishuwu/book/57)
# mysql
[mysql博客](https://www.cnblogs.com/liang545621/p/9400104.html)
# 算法
[排序](https://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247486547&idx=1&sn=e8ae3bfc43238b19062639846afd99e6&scene=21#wechat_redirect)
https://www.v2ex.com/t/609492#reply70
https://github.com/shidenggui
[ShowMeBug 核心技术内幕](https://www.v2ex.com/t/617216#reply17)
[dns](https://www.cnblogs.com/cobbliu/category/443082.html)
[设计模式参考](http://javavipblog.com/categories/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/)
[内网穿透工具(替代 ngrok 和花生壳)](https://www.v2ex.com/t/617484#reply95)
https://www.neiwangchuantou.vip/
社区https://www.v2ex.com/t/618024#reply15

# 官方文档
[sp官方文档](https://docs.spring.io/spring-boot/docs/2.0.0.RELEASE/reference/htmlsingle/#howto-two-datasources)
https://docs.spring.io/spring-boot/docs/2.1.4.RELEASE/reference/htmlsingle/#howto-two-datasources
[jse包，文档](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/module-summary.html)
[h2](http://h2database.com/html/tutorial.html#android)
[mybatis-plus](https://github.com/baomidou/mybatis-plus-doc/tree/master/guide)
[studygolang](https://studygolang.com/)


orm框架：
https://mybatis.org/mybatis-dynamic-sql/docs/conditions.html

https://www.jianshu.com/p/29ca7ceba6d4?utm_campaign=haruki

http://t.zoukankan.com/jhxxb-p-10493844.html

https://segmentfault.com/a/1190000021217732?utm_source=tag-newest
https://www.cnblogs.com/xingzc/p/5761562.html

插入数据后，返回主键id
https://blog.csdn.net/yueloveme/article/details/78483072

mybatis使用注解
https://www.cnblogs.com/linjiqin/p/9686981.html
https://blog.51cto.com/zero01/2093584
https://blog.csdn.net/weixin_33755847/article/details/92613413


配置问题
https://www.cnblogs.com/xfk1999/p/spring-boot-no-mybatis-mapper-was-found.html









# 前端
作品:https://shiroi.netlify.com/
https://github.com/alo7
简历这么写：https://github.com/resumejob/awesome-resume/blob/master/README.md
https://github.com/tagnja/resources-of-learning/blob/master/%23cs-foundations.md#os_t
前端100题：https://juejin.im/post/5d23e750f265da1b855c7bbe?utm_source=gold_browser_extension#heading-110
https://github.com/biaochenxuying/blog


## 站长工具
[查看本级外网Ip，还有服务商](https://www.opengps.cn/?form=v2ex)
[开发工具，时间戳、dns等](https://tool.lu/timestamp/)
[开发工具，站长工具](https://www.dute.org/)
[cdn检测](http://cdn.chinaz.com/search/?host=www.qq.com)

## 下载
[ide主题下载](http://color-themes.com/?view=help)  
[windows镜像下载](https://msdn.itellyou.cn/)
[密钥](http://www.xitongcheng.com/jiaocheng/dnrj_article_46771.html)
[淘宝镜像](http://npm.taobao.org/mirrors/git-for-windows/v2.25.0.windows.1/)


[图床](https://sm.ms/)

[谷歌浏览器插件网](http://chromecj.com/)



# 图床
[图床](https://imgchr.com/)





# 个人博客
[qoogle.top](https://qoogle.top)
[cooler](https://www.v2ex.com/member/ihainan)
[luolei一个前前端](https://luolei.org/nintendo-switch-unboxing/)
[github1](https://github.com/yueshutong)
[quake0day](http://www.quake0day.com/tagged/%E6%97%A5%E8%AE%B0/page/13)				
[quake0day](http://www.quake0day.com/tagged/%E4%BD%9C%E5%93%81/page/2)				
[quake0day_github](https://github.com/quake0day/Platform/tree/master/config)				
[quake0day](https://www.darlingtree.com/)	

[morefreeze](https://github.com/morefreeze)
[morefreeze](https://morefreeze.github.io/)
[morefreeze](https://www.toutiao.io/u/130622)

[yangqianru](http://yangqianru.com/index.html#/learn/English/844.html)

[vamei](https://www.cnblogs.com/vamei)

[ruanyifeng](http://www.ruanyifeng.com/blog/)
https://blog.csdn.net/ChrisSen/article/details/100060434
https://github.com/chrissen0814
https://github.com/brain-zhang
https://github.com/julvo
https://github.com/NtesEyes
https://github.com/budui
https://github.com/awesome-selfhosted/awesome-selfhosted


[旧安卓去处](https://blog.csdn.net/Greepex/article/details/85333027)





			


[mysql中Incorrect string value乱码问题解决方案][https://my.oschina.net/lixin91/blog/639270]

[vimwiki](https://www.douban.com/note/542255008/)			
[vimwiki](https://www.cnblogs.com/taosim/articles/3373670.html)	

[python-Fabric](http://docs.fabfile.org/en/2.4/getting-started.html#transfer-files)







# 负载均衡
https://blog.csdn.net/lihao21/article/details/54646297
#1212
https://www.imooc.com/search/article?words=spark

304不是错误。是请求一下图片，如果图片在上次访问后没有更新过，就不用下载了，返回304，叫浏览器直接用cache里的
[安装苹果虚拟机](https://blog.csdn.net/qq_27404929/article/details/99816806)


[新闻](https://chuansongme.com/utility)
[今日热榜1](https://ttop5.net/to-be-slack/#/?id=1)
[今日热榜2](https://tophub.today/)
[热点聚合，偏it](https://hot.const520.com/?tab=ifanr)
[鱼塘](https://mo.fish/)
[news](http://www.techweb.com.cn/)
[huxiu](https://www.huxiu.com/)
[少数派](https://sspai.com/)
[442](https://www.fourfourtwo.com/)
[果壳](https://www.guokr.com/ask/)

[财经站点](https://upsort.com/)
[财经](http://www.fortunechina.com/)  
  
 
[无聊时，怀旧小游](https://dos.zczc.cz/)

# 英语
[谷歌翻译](https://translate.google.cn/)
[必应词典](https://cn.bing.com/dict/)
[英语打开学习](https://v2en.co/:daily) 
[学外语](http://www.duolingo.cn/register)

# 读书
[微信读书](https://weread.qq.com/#search)
[豆瓣读书](https://read.douban.com/reader/ebook/35648568/?from=book)

# movies
[电影](https://www.imdb.com/) 
[电影下载](https://www.dy2018.com/html/gndy/dyzz/index.html)

# 其他
[设计](https://www.zcool.com.cn/)
[站点分享](https://caocao.boxopened.com/)
[育儿](https://www.jianshu.com/p/7e66d711859a)	


# 历史
[故宫](https://www.dpm.org.cn/Home.html)
[全历史](https://www.allhistory.com/)

# podcast
[推荐的1](https://www.douban.com/doulist/4228036/)
[npr播客](https://www.npr.org/sections/movies/)
[推荐的2](https://www.zhihu.com/topic/19562690/hot)
[音乐磁场](https://www.hifini.com/)
[音乐资源](https://www.404dy.com/bangdan/)
[无损音乐资源1](http://www.wsyyb.com/hires/)
[无损音乐资源2](https://www.sq688.com/)

# 柴米油盐
[北京人力资源与社会保障居](http://rsj.beijing.gov.cn/)
[北京社保查询](http://rsj.beijing.gov.cn/csibiz/) 246
[北京缴纳的社保比例](https://zhidao.baidu.com/question/226902665.html)

[mac工具](https://mp.weixin.qq.com/s/8c-94YhOd5fLJbScW4MnFw)
[Sublime Text 快捷键（MAC环境）](https://blog.csdn.net/weixin_34116110/article/details/94023390)

[excel技巧](https://post.smzdm.com/p/akmgrnek/)
软件为了能运行顺畅，规定了Excel中的数字只能精确显示到第 15 位，超过 15 位之后，都用“0”代替。这种常常出现在身份证、银行卡、社保账号、业务编号等数字上，并且这种错误不注意可能根本看不出。

方法1：输入身份证号码前，在单元格里先输入一个半角单引号“`”


https://www.baiduwp.com/

https://github.com/tomoya92/pylog
https://www.wallmama.com/lantern/
https://github.com/vimwiki/vimwiki/blob/dev/doc/vimwiki.txt
https://wangheng.org/html/vimwiki.html
https://lutaonan.com/
https://github.com/bannedbook/fanqiang/wiki/Chrome%E4%B8%80%E9%94%AE%E7%BF%BB%E5%A2%99%E5%8C%85
https://zh.wikipedia.org/wiki/%E7%AA%81%E7%A0%B4%E7%BD%91%E7%BB%9C%E5%AE%A1%E6%9F%A5
https://www.vpndada.com/best-vpns-for-china-cn/
https://github.com/bannedbook
https://www.bbc.com/zhongwen/simp/chinese-news-46823319



https://www.wanweibaike.com/
https://en.wanweibaike.com/
https://dumps.wikimedia.org/

[kafka原理](https://www.cnblogs.com/sujing/p/10960832.html)
[更多消息组件](https://cloud.tencent.com/developer/article/1165583)
kafka消息过期时间设置
https://blog.csdn.net/u012809308/article/details/110006925
打上.deleted 的标记
有专门的删除日志定时任务过来扫描，发现.deleted文件就会将其从磁盘上删除，释放磁盘空间，至此kafka过期消息删除完成。

kafka删除消息是以segment为维度的，而不是以具体的一条条消息为维度。
https://blog.csdn.net/weixin_38750084/article/details/83037938?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ETopBlog-1.topblog&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ETopBlog-1.topblog&utm_relevant_index=1

https://blog.csdn.net/zhangshenghang/article/details/89152644





https://doc.akka.io/docs/akka/current/guide/actors-motivation.html
[github提速](https://mp.weixin.qq.com/s?__biz=MzUxOTk2Njc0OQ==&mid=2247487335&idx=1&sn=2cfdb41c2ec3bc2bccebee026b3f79e1&scene=21#wechat_redirect)
[mac历史剪切板 option command c](https://zhuanlan.zhihu.com/p/33515314)


[数据挖掘之路kaggle](https://www.kaggle.com/)


给大家分享一下设置临时代理的方法。
终端执行 export ALL_PROXY=socks5://127.0.0.1:1080 可设置临时代理。
但每次执行这个命令有点长，于是可以通过设置别名，在用户主目录下的 .bash_profile 添加如下代码，这样以后在使用的时候就可以直接输入 proxy 启用代理，unproxy 关闭代理了
alias proxy="export ALL_PROXY=socks5://127.0.0.1:1080"
alias unproxy="unset ALL_PROXY"


git 不用设置全局代理，可以配置单域名代理：
HTTP/HTTPS 协议（注意，git 配置里代理设置不管 http 还是 https 都是 http.proxy ）：
git config --global 'http.https://github.com.proxy' 'socks5h://localhost:port'
SSH 协议：
编辑 ~/.ssh/config 文件，添加：
Host github.com
ProxyCommand /usr/bin/nc -X 5 -x localhost:port %h %p
（ nc 是 BSD 的 netcat 工具，%h %p 原样保留不用替换）


https://www.ctolib.com/nodejs/docs/

https://nqdeng.github.io/7-days-nodejs/


https://www.yiibai.com/nodejs
https://www.jianshu.com/p/729c4fe7f93c
https://www.zcfy.cc/article/the-most-popular-node-js-tutorials-of-2017-risingstack

https://nodejs.jakeyu.top/
http://www.runoob.com/nodejs/nodejs-tutorial.html

https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/001434501245426ad4b91f2b880464ba876a8e3043fc8ef000


https://www.nodebeginner.org/index-zh-cn.html


https://m.w3cschool.cn/nodejs/

https://www.zhihu.com/question/19793473

https://www.bilibili.com/video/av21010015/
https://www.bilibili.com/video/av22416708/
https://www.bilibili.com/video/av22056141/


[双拼练习](https://api.ihint.me/shuang/)

* 书籍库 https://trello.com/b/Y0CSKDM5/%E4%B9%A6%E7%B1%8D%E5%BA%93
* 备忘录 https://trello.com/b/yPLqQglA/%E5%A4%87%E5%BF%98%E5%BD%95
* 涂鸦板 https://trello.com/b/tDmJHLP8/%E6%B6%82%E9%B8%A6%E6%9D%BF
* 终点线 https://trello.com/b/7GmYGYIG/%E7%BB%88%E7%82%B9%E7%BA%BF
* 起跑线 https://trello.com/b/mmevdrzu/%E8%B5%B7%E8%B7%91%E7%BA%BF
* 训练中 https://trello.com/b/pta1tN5Q/%E8%AE%AD%E7%BB%83%E4%B8%AD
* 私货 https://trello.com/b/N8yVP3ts/%E7%A7%81%E8%B4%A7


应用架构演进

# 传统垂直架构：
mvc模式开发
存在的一些问题：1. 业务不断发展，功能逐渐增多，应用的开发维护成本变高，部署效率降低，随便改个代码，编译一次十几分钟就浪费了。悲剧，我们有个系统才开发3年，就碰到这种情况，一次打包编译部署，13分钟结束。2. 不同的人负责不同的部分，一些通用代码、公共代码就各写各的，不能复用，如果只是util还好，但是一些外部服务的都有重复，那就happy了（不过这种情况的出现，不一定是架构问题，更多可能是管理）；3. 不断地上新需求，不断地改代码，有时测试不到位，指定哪里埋了bug，上生产后系统就down了，牵一发而动全身；4. 可维护性，可靠性，扩展性变差。

# SOA服务化架构
解决异构系统的交互，通常的实现是通过ESB，WSDL来处理。其粒度通常来说是比较粗的。也存在服务治理方面的问题。

# RPC架构
Remote Procedure Call，远程方法调用，屏蔽底层实现细节，像调用本地方法一样调用远程服务，并且屏蔽编程语言的差异性。。
要实现上述目标首先需要设计一种通信协议，这被称为————RPC协议(RPC Protocol)
它不是某一个具体的协议，而是一个类型名，代表一类用作RPC的协议。
RPC协议是在网络应用层协议，广义上可以跨越平台、语言进行应用间通讯（说广义是因为可以开发一个协议但只支持单个语言）。

![rpc框架原理](https://user-gold-cdn.xitu.io/2018/9/29/16624be2667b9873?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
[你应该知道的RPC原理](https://www.cnblogs.com/LBSer/p/4853234.html)

实现的几个技术点：
1. 服务提供者发布服务：服务接口定义，数据结构，服务提供者信息等；
2. 客户端远程调用：通常是使用jdk的代码代理拦截；
3. 底层通信：现在应该更多是使用netty吧，当然也有走支持http的；
4. 序列化：关注序列化反序列性能，xml，json，hessiaon，pb，protostuff，kryo等。

常用的rpc框架1. Thrift；2. Hadoop的Avro-RPC;3.Hessian；4.gRPC; dubbo
单论rpc的话，没太多可说的，可是如果加上服务治理，那复杂度就几何倍数增长了。服务治理里面东西太多了，动态注册，动态发现，服务管控，调用链分析等等问题这些问题，单凭rpc框架解决不了，所以现在常用的说的服务化框架，通常指的是rpc+服务治理2个点。

# 微服务MSA
也是一种服务化架构风格，正流行ing，服务划分1.原子服务，粒度细；2.独立部署，主要是容器。
## MSA与SOA的对比
服务拆分粒度：soa首要解决的是异构系统的服务化，微服务专注服务的拆分，原子服务；
服务依赖：soa主要处理已有系统，重用已有的资产，存在大量服务间依赖，微服务强调服务自治，原子性，避免依赖耦合的产生；
服务规模：soa服务粒度大，大多数将多个服务合并打包，因此服务实例数有限，微服务强调自治，服务独立部署，导致规模膨胀，对服务治理有挑战；
架构差异：微服务通常是去中心化的，soa通常是基于ESB的；
服务治理：微服务的动态治理，实时管控，而soa通常是静态配置治理；
交付：微服务的小团队作战。
感觉在有了docker后，微服务这个概念突然火了起来，总结就是微服务+容器+DevOps。

---
---
title: 书签
date: 2021/3/22 21:46:25
tags: bookmark
categories: tools
---

# 工具
[储物间](http://kyon945.ys168.com/)
## 画图
[在线ps](https://www.tuyitu.com/photoshop/)


# 地图
http://www.google.cn/maps
https://www.google.com.hk/
[查经纬度](https://jingweidu.51240.com/)
[腾讯坐标拾取器](https://lbs.qq.com/tool/getpoint/index.html)


# 论坛
[wikihow](https://zh.wikihow.com/%E9%A6%96%E9%A1%B5)
[程序员叨叨](https://www.v2ex.com/)  
[有趣的地方](https://zhaodao.ai/)
[杂家论坛](http://www.rdonly.com)
[运维社区](http://dockone.io/)
[独立开发者社区](https://indiehackers.net/)
[github榜单，中文](https://github.com/kon9chunkit/GitHub-Chinese-Top-Charts)
[github作文社区](https://www.githubs.cn/)
[Laravel China 社区](https://learnku.com/laravel)
[一个测试社区](https://testerhome.com/jobs)  
[infoQ](http://dy.163.com/v2/article/detail/EC7E9EEQ0511D3QS.html)
[美团技术论坛](https://tech.meituan.com/)
[ali-git](https://github.com/alibaba)
[csdn开发贴子](https://www.csdn.net/)
[英文growthhackers](https://growthhackers.com/posts)
[小程序集结](https://minapp.com/miniapp/12017/)
[创造者日报，小程序](https://creatorsdaily.com/?topic=7e0c8978-d906-432e-9265-edb626978f87)
[www.worldcommunitygrid.org](https://www.worldcommunitygrid.org/discover.action?recruiterId=1091061#comparisons)


# 视频流
[参考](https://www.hangge.com/blog/cache/detail_1325.html)
苹果提供的测试：http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8
央视新闻频道：http://223.110.245.171/PLTV/3/224/3221225560/index.m3u8
央视5+：http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8
央视1台：http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8
央视3：http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8
電影頻道：http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8


[新闻](https://chuansongme.com/utility)
[今日热榜1](https://ttop5.net/to-be-slack/#/?id=1)
[今日热榜2](https://tophub.today/)
[热点聚合，偏it](https://hot.const520.com/?tab=ifanr)
[鱼塘](https://mo.fish/)
[news](http://www.techweb.com.cn/)
[huxiu](https://www.huxiu.com/)
[少数派](https://sspai.com/)
[442](https://www.fourfourtwo.com/)
[果壳](https://www.guokr.com/ask/)

[财经站点](https://upsort.com/)
[财经](http://www.fortunechina.com/)  
  
 
[无聊时，怀旧小游](https://dos.zczc.cz/)

# 英语
[谷歌翻译](https://translate.google.cn/)
[必应词典](https://cn.bing.com/dict/)
[英语打开学习](https://v2en.co/:daily) 
[学外语](http://www.duolingo.cn/register)

# 读书
[微信读书](https://weread.qq.com/#search)
[豆瓣读书](https://read.douban.com/reader/ebook/35648568/?from=book)

# movies
[电影](https://www.imdb.com/) 
[电影下载](https://www.dy2018.com/html/gndy/dyzz/index.html)

# 其他
[设计](https://www.zcool.com.cn/)
[站点分享](https://caocao.boxopened.com/)
[育儿](https://www.jianshu.com/p/7e66d711859a)	

# shopping
[京东优惠券](https://coupon.zpfdev.com/)

# 历史
[故宫](https://www.dpm.org.cn/Home.html)
[全历史](https://www.allhistory.com/)

# podcast
[推荐的1](https://www.douban.com/doulist/4228036/)
[npr播客](https://www.npr.org/sections/movies/)
[推荐的2](https://www.zhihu.com/topic/19562690/hot)
[音乐磁场](https://www.hifini.com/)
[音乐资源](https://www.404dy.com/bangdan/)
[无损音乐资源1](http://www.wsyyb.com/hires/)
[无损音乐资源2](https://www.sq688.com/)

# 柴米油盐
[北京人力资源与社会保障居](http://rsj.beijing.gov.cn/)
[北京社保查询](http://rsj.beijing.gov.cn/csibiz/) 246
[北京缴纳的社保比例](https://zhidao.baidu.com/question/226902665.html)


SELECT * from cost_test WHERE id < 10  

1205 - Lock wait timeout exceeded; try restarting transaction, Time: 51.132000s


关于幻读概念的修正，参考：https://zhuanlan.zhihu.com/p/103580034
1、删除操作，而非插入操作时，归为 不可重复读”？


MVCC 带来的好处？
为了保证并发事务的安全，一个比较容易想到的办法就是加读写锁，实现：读读不冲突、读写冲突、写读冲突，写写冲突，在这种情况下，并发读写的性能必然会收到严重影响。



带着理解、带着思考去看，将题目与实际开发的内容结合去理解，这样很容易就记下来了

定时将百万行级别的文件进行下载、读取数据、插入数据库，并进行一些业务操作。（其实就是NIO读取，多线程都没开，整个处理要一两个小时...）

使用多线程处理通过Excel导入的数据。（就开了个线程异步处理...）

批量处理通过Excel导入的数据。（好像就是个批量插入数据库...）
mybatis 中的 DAO 接口和 XML 文件里的 SQL 是如何建立关系的？
 对象在内存中的初始化过程

第2和第3点其实就是来凑数的，打扰了。
————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/106463578


如果为null就不返回

解决办法
方法一：通过在返回实体类上添加注解

@JsonInclude(JsonInclude.Include.NON_NULL)
1
方法二：通过application.properties（或者去yml中配置）

#设置不返回null字段
spring.jackson.default-property-inclusion=non_null
————————————————
版权声明：本文为CSDN博主「倒骑驴走着瞧」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/nongminkouhao/article/details/106892590

[远程调试](https://blog.csdn.net/LGM_lx/article/details/83619038)

[mybatis](https://mybatis.org/mybatis-3/zh/dynamic-sql.html)

[java面试](https://mp.weixin.qq.com/s?__biz=MzUyMTY4MTk2OA==&mid=2247487391&idx=3&sn=b9b73eb202d78b08cdf9306cbdb8eb4f&chksm=f9d622c0cea1abd6f20f0f2aed272914c562bc9482cdd3cc6bc1be75cdaecc1849e1d0049877&mpshare=1&scene=1&srcid=061152UbQKozLnY30geVfwax#rd)

[mac快捷键

 - List item

](https://www.jianshu.com/p/e86c35294d05)

[Spring-data-redis](http://ebook4download.net/article/310309.html)
[gate to bigdata](https://zhuanlan.zhihu.com/p/245443586)

[spark整合hive](https://www.cnblogs.com/intsmaze/p/6618841.html)

[kafka原理](https://www.jianshu.com/p/734cf729d77b)

[postman教程](https://zhuanlan.zhihu.com/p/141948716)

[打印日志sout](https://my.oschina.net/zjllovecode/blog/1538380)
[log4j](https://blog.csdn.net/xundh/article/details/80256607)


[一个tcp案例](https://blog.csdn.net/stpeace/article/details/44162349)

[coding in jp](https://mp.weixin.qq.com/s/K7uZO-WZyf0t2afRakSN8Q)


[how to be leader](https://segmentfault.com/a/1190000021273540)

# 关于分布式
[rpc原理](https://www.cnblogs.com/LBSer/p/4853234.html)

[一致性问题cap的c](https://www.iteye.com/blog/elf8848-2067771)

[应对雪崩](https://blog.csdn.net/fyxxq/article/details/43983721)












[通过一个案例认知JVM 的内存管理/回收和进程上内存的关系](https://segmentfault.com/a/1190000040050819?utm_source=sf-homepage)  
  
[复习jvm](https://m.imooc.com/wiki/jvm-jvmframe)
  
  
[参考](https://www.cnblogs.com/pxset/p/11126585.html)  
JVM是一种用于计算设备的规范，它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。   
负责执行指令，管理数据、内存、寄存器。   
不同的平台，有不同的jvm。  
  
在高并发情况下，对程序的性能、稳定性、可扩展性方面有较高的要求，提升硬件效能无法等比例地提升程序的运作性能和并发能力，这里有java虚拟机的原因。    
如果开发不了解虚拟机一些技术特性和运行原理，就无法写出最适合虚拟机运行和自优化的代码。  
（然而最重要的还是应付面试）  
  
## 跨平台性  
JVM屏蔽了与具体操作系统平台相关的信息，使Java程序只需生成在Java虚拟机上运行的目标代码（字节码）,就可以在多种平台上不加修改地运行。JVM在执行字节码时，实际上最终还是把字节码解释成具体平台上的机器指令执行。      
  
# JVM内存结构  
内存区域是指 Jvm 运行时将数据分区域存储，强调对内存空间的划分。  
线程私有的内存区域有虚拟机栈、本地方法栈、程序计数器；而线程共享的区域有堆、方法区。  
![](http://pxset.oss-cn-beijing.aliyuncs.com/blog/jvm-runtime-memory.png)  
  
除了这些，还有一部分内存也被频繁使用，它不是运行时数据区的一部分，也不是Java虚拟机规范中定义的内存区域——**直接内存Direct Memory**或堆外内存。  
直接内存的分配不受Java堆大小的限制，但是他还是会受到服务器总内存的影响。可以通过-XX:MaxDirectMemorySize 来限制它的大小（默认与堆内存最大值一样），所以也会出现 OutOfMemoryError 异常。  
如果使用了 NIO,这块区域会被频繁使用，在 java 堆内可以用`directByteBuffer`对象直接引用并操作；  
  
其他堆外内存，主要是指使用了 Unsafe 或者其他 JNI 手段直接直接申请的内存。  
  
## 计数器/PC寄存器（Program Counter Register）  
每个线程都有一个独立的计数器，可以看作是当前线程所执行的字节码的行号指示器，用来记录线程执行的虚拟机字节码指令。  
1、字节码解释器工作时通过改变这个计数器的值来选取下一条需要执行的字节码指令，分支、循环、跳转、异常处理、线程恢复等功能都需要依赖这个计数器来完成。  
2、在多线程的情况下，程序计数器用于记录当前线程执行的位置，从而当线程被切换回来的时候能够知道该线程上次运行到哪儿了。  
另外，如果是Native方法，则计数器中的值为undifined。  
本地方法（native 方法），不是 JVM 来具体执行，在操作系统层面也有一个程序计数器，这个  
会记录本地代码的执行的地址，所以在执行 native 方法时，JVM 中程序计数器的值为空(Undefined)。  
  
各线程之间计数器互不影响，独立存储，为“线程私有”的内存。  
  
程序计数器是`唯一一个不会出现 OutOfMemoryError 的内存区域`，它的生命周期随着线程的创建而创建，随着线程的结束而死亡。  
  
## 虚拟机栈  
每个线程创建的同时都会创建JVM栈内存， Java 虚拟机栈描述的是 Java 方法执行的内存模型，每次方法调用的数据都是通过栈传递的。  
由一个个栈帧(stack frame)组成，而每个栈帧中都拥有：局部变量表（基本类型变量，非基本类型的对象引用）、操作数栈、动态链接、方法出口信息、部分的返回结果。  
每个方法调用会在栈上划出一块作为栈帧。一个方法从开始执行到结束的过程，就是一个栈帧在虚拟机栈中入栈到出栈的过程。    
![](https://img2020.cnblogs.com/blog/1331583/202009/1331583-20200910104748652-1736004103.png)  
  
### 栈的内存溢出  
Java 虚拟机栈会出现StackOverFlowError  
`StackOverFlowError`： `当线程请求栈的内存大小超过的时候`，就抛出StackOverFlowError异常。  
方法无限递归调用时候会出现（栈空间装不下无限进入的栈帧了）。  
  
##  本地方法栈（Native Method Stacks）  
JVM采用本地方法堆栈来支持native方法（用 C++ 写的）的执行，此区域用于存储每个native方法调用的状态。  
方法执行完毕后相应的栈帧也会出栈并释放内存空间，也会出现 StackOverFlowError 和 OutOfMemoryError 两种错误。  
  
-Xss设置每个线程的堆栈（stack+native stack）大小  
  
##  堆（Heap）  
它是JVM用来存储对象实例以及数组值的区域，可以认为Java中所有通过new创建的对象的内存都在此分配，Heap中的对象的内存需要等待GC进行回收。是垃圾收集器管理的主要区域，因此也被称作`GC堆`。在虚拟机启动时创建。  
  
一个对象创建的时候，到底是在堆上分配，还是在栈上分配呢？  
这和两个方面有关：对象的类型和在 Java 类中存在的位置。  
Java 的对象可以分为基本数据类型和普通对象。  
对于普通对象来说，JVM 会首先在堆上创建对象，然后在其他地方使用的其实是它的引用。比如，把这个引用保存在虚拟机栈的局部变量表中。  
对于基本数据类型来说（byte、short、int、long、float、double、char)，有两种情况。  
当你在方法体内声明了基本数据类型的对象，它就会在栈上直接分配。其他情况，都是在堆上分配。  
  
Java堆可以处于物理上不连续的内存空间中，只要逻辑上是连续的即可，就像我们的磁盘空间一样。在实现时，既可以实现成固定大小的，也可以是可扩展的，不过当前主流的虚拟机都是按照可扩展来实现的（通过-Xmx和-Xms控制）。  
  
由于现在收集器基本都采用分代垃圾收集算法，所以 Java 堆还可以细分为：新生代和老年代：新生代再细致一点分为：Eden 空间、From Survivor、To Survivor 空间（默认情况下年轻代按照8:1:1的比例来分配）。进一步划分的目的是更好地回收内存，或者更快地分配内存。  
  
大部分情况，对象都会首先在 Eden 区域分配，在一次Eden 区垃圾回收后，如果对象还存活，则会进入 s0 或者 s1(这两个区功能上是交替的)，并且对象的年龄还会加  1(Eden 区->Survivor 区后对象的初始年龄变为 1，s0区的对象经过一次gc后会进入s1，s1区的对象经过一次gc会进入s0)，当它的年龄增加到一定阈值，就会被晋升到老年代中。  
>[Hotspot遍历所有对象时，按照年龄从小到大对其所占用的大小进行累积，当累积的某个年龄大小超过了survivor区的一半时，取这个年龄和MaxTenuringThreshold（默认为 15，可以通过参数 `-XX:MaxTenuringThreshold` 来设置）中更小的一个值，作为晋升到老年代的年龄阈值](https://github.com/Snailclimb/JavaGuide/issues/552)。  
  
  
  
1）堆是JVM中所有线程共享的，因此在其上进行对象内存的分配均需要进行加锁，这也导致了new对象的开销是比较大的  
2） Sun Hotspot JVM为了提升对象内存分配的效率，对于所创建的线程都会分配一块独立的空间TLAB（Thread Local Allocation Buffer），其大小由JVM根据运行的情况计算而得，在TLAB上分配对象时不需要加锁，因此JVM在给线程的对象分配内存时会尽量的在TLAB上分配，在这种情况下JVM中分配对象内存的性能和C基本是一样高效的，但如果对象过大的话则仍然是直接使用堆空间分配  
3）TLAB仅作用于新生代的Eden Space，因此在编写Java程序时，通常多个小的对象比大的对象分配起来更加高效。  
4）所有新创建的Object 都将会存储在新生代Yong Generation中。如果Young Generation的数据在一次或多次GC后存活下来，那么将被转移到OldGeneration。新的Object总是创建在Eden Space。  
  
  
### 堆的内存溢出  
堆这里最容易出现的就是  OutOfMemoryError 错误，并且出现这种错误之后的表现形式还会有几种，比如：  
`OutOfMemoryError: GC Overhead Limit Exceeded` ： 当JVM花太多时间执行垃圾回收并且只能回收很少的堆空间时，就会发生此错误。  
`java.lang.OutOfMemoryError: Java heap space` :假如在创建新的对象时, 堆内存中的空间不足以存放新创建的对象, 就会引发java.lang.OutOfMemoryError: Java heap space 错误。(和本机物理内存无关，和你配置的对内存大小有关！)  
  
### 堆的参数控制  
-Xms设置堆的最小空间大小；  
-Xmx设置堆的最大空间大小；  
-XX:NewSize设置新生代最小空间大小；（-Xmn）  
-XX:MaxNewSize设置新生代最大空间大小。  
-XX:OldSize: 老年代的默认大小, default size of the tenured generation（测试验证JDK1.8.191该参数设置无效，JDK11下设置成功）可以设置堆空间大小和新生代空间大小两个参数来间接控制:老年代空间大小=堆空间大小-年轻代大空间大小。  
-XX:NewRatio: 老年代对比新生代的空间大小, 比如2代表老年代空间是新生代的两倍大小. The ratio of old generation to young generation.  
  
将堆的最小值-Xms参数与最大值-Xmx参数设置为一样即可避免堆自动扩展，参数-XX:+HeapDumpOnOutOfMemoryError可让虚拟机在出现内存溢出是Dump出当前的内存堆转储快照以便时候进行分析。  
![](https://img2020.cnblogs.com/blog/1331583/202008/1331583-20200816221419254-745001274.png)  
单位：B  
与设置的会有一丢丢偏差  
  
##  方法区（Method Area）  
存放已被虚拟机加载的类信息（类的名称、版本、修饰符、方法、常量池和Field的引用信息等）、运行时常量池、即时编译器编译后的机器指令等。当开发人员在程序中通过Class对象中的getName、isInterface等方法来获取信息时，这些数据都来源于方法区域，同时方法区域也是全局共享的  
注意：（在Java 8 之前），方法区仅是逻辑上的独立区域，在物理上并没有独立于堆而存在，而是`位于永久代PermanetGeneration`中。java8永久代最终被移除，方法区移至 元空间Metaspace，元空间使用的是直接内存。  
>永久代就是 HotSpot 虚拟机对虚拟机规范中方法区的一种实现方式。 也就是说，永久代是 HotSpot 的概念，方法区是 Java 虚拟机规范中的定义，是一种规范，而永久代是一种实现，一个是标准一个是实现，`其他的虚拟机实现并没有永久代这一说法`。  
  
垃圾收集行为在这个区域是比较少出现的，但并非数据进入方法区后就“永久存在”了。  
这个区域的内存回收目标主要是针对常量池的回收和对类型的卸载，一般来说这个区域的回收“成绩”比较难以令人满意，尤其是类型的卸载，条件相当苛刻，但是这部分区域的回收确实是有必要的。  
  
### 相关参数  
1.8前：  
-XX:PermSize=N //方法区 (永久代) 初始大小  
-XX:MaxPermSize=N //方法区 (永久代) 最大大小,超过这个值将会抛出 OutOfMemoryError 异常:java.lang.OutOfMemoryError: PermGen  
  
1.8：  
-XX:MetaspaceSize=N //设置 Metaspace 的初始（和最小大小）。如果未指定，Metaspace 将根据运行时的应用程序需求动态地重新调整大小  
-XX:MaxMetaspaceSize=N //设置 Metaspace 的最大大小。溢出时会得到如下错误： java.lang.OutOfMemoryError: MetaSpace  
默认值为 unlimited，这意味着它只受系统内存的限制，如果不指定大小的话，随着更多类的创建，虚拟机会耗尽所有可用的系统内存。  
  
### 为什么要将永久代 (PermGen) 替换为元空间 (MetaSpace) 呢？  
https://www.sczyh30.com/posts/Java/jvm-metaspace/  
1、永久代内存经常不够用或发生内存溢出，抛出异常 java.lang.OutOfMemoryError: PermGen。这是因为在 JDK1.7 版本中，指定的 PermGen 区大小为  
8M，由于 PermGen 中类的元数据信息在每次 FullGC 的时候都可能被收集，回收率都偏低，成绩很难令人满意；还有为 PermGen 分配多大的空间很难  
确定，PermSize 的大小依赖于很多因素，比如，JVM 加载的 class 总数、常量池的大小和方法的大小等。  
虽然元空间仍旧可能溢出，但是比原来出现的几率会更小。元空间使用的是直接内存，受本机可用内存非 JVM内存的限制，能加载的类就更多了。  
2、可以促进 HotSpot JVM 与 JRockit VM 的融合，因为 JRockit 没有永久代。  
  
### 常量池（Constant Pool Table）  
是方法区的一部分。属于类的信息，包括字符串常量池以及所有基本类型都有其相应的常量池。用于存放编译期生成的各**种字面量和符号引用**。  
字面量包括字符串（String a=“b”）、基本类型的常量（final 修饰的变量），符号引用则包括类和方法的全限定名（例如 String 这个类，它的全限定名  
就是 Java/lang/String）、字段的名称和描述符以及方法的名称和描述符。  
  
#### 符号引用  
一个 java 类（假设为 People 类）被编译成一个 class 文件时，如果 People 类引用了 Tool 类，但是在编译时 People 类时并不知道引用类的实际内存地址，因此只能使用符号引用（org.simple.Tool ）来代替。  
而在类装载器装载 People 类时，此时可以通过虚拟机获取 Tool 类的实际内存地址，因此便可以既将符号 org.simple.Tool 替换为 Tool 类的实际内存地址，及直接引用地址。  
即在编译时用符号引用来代替引用类，在加载时再通过虚拟机获取该引用类的实际地址。以一组符号来描述所引用的目标，符号可以是任何形式的字面量，只要使用时能无歧义地定位到目标即可。符号引用与虚拟机实现的内存布局是无关的，引用的目标不一定已经加载到内存中。   
  
### 运行时常量池（Runtime Constant Pool）  
https://blog.csdn.net/wangbiao007/article/details/78545189  
动态常量池里的内容除了是静态常量池（class文件常量池）里的内容外，还将静态常量池里的符号引用转变为直接引用（对象的索引值），而且动态常量池里的内容是能动态添加的。  
例如调用String的intern方法就能将string的值添加到String常量池中，这里String常量池是包含在动态常量池里的，但在jdk1.8后，将String常量池放到了堆中。  
  
>当类加载到内存后，JVM 就会将 class 文件常量池中的内容存放到运行时常量池中；在解析阶段，JVM 会把符号引用替换为直接引用（对象的索引值）。  
eg:类中的一个字符串常量在 class 文件中时，存放在 class 文件常量池中的。  
在 JVM 加载完类之后，JVM 会将这个字符串常量放到运行时常量池中，并在解析阶段，指定该字符串对象的索引值。  
  
运行时常量池是全局共享的，多个类共用一个运行时常量池，因此，class 文件中常量池多个相同的字符串在运行时常量池只会存在一份。  
```  
 public static void main(String[] args) { String str = "Hello"; System.out.println((str == ("Hel" + "lo")));  
 String loStr = "lo"; System.out.println((str == ("Hel" + loStr)));  
 System.out.println(str == ("Hel" + loStr).intern()); }```  
第一个为 true，是因为在编译成 class 文件时，能够识别为同一字符串的, JVM 会将其自动优化成字符串常量,引用自同一 String 对象。  
第二个为 false，是因为在运行时创建的字符串具有独立的内存地址,所以不引用自同一 String 对象。  
第三个为 true，是因为 String 的 intern() 方法会查找在常量池中是否存在一个相等(调用 equals() 方法结果相等)的字符串,如果有则返回该字符串的引用,如果没有则添加自己的字符串进入常量池。  
  
JDK1.7 及之后版本的 JVM 已经将运行时常量池从方法区中移了出来，在 Java 堆（Heap）中开辟了一块区域存放运行时常量池。  
在 JDK1.8 中，使用元空间代替永久代来实现方法区，但是方法区并没有改变，所谓"Your father will always be your father"。变动的只是方法区中内容的物理存放位置，但是运行时常量池和字符串常量池被移动到了堆中。但是不论它们物理上如何存放，逻辑上还是属于方法区的。  
  
>常量池有很多概念，包括运行时常量池、class 常量池、字符串常量池。  
虚拟机规范只规定以上区域属于方法区，并没有规定虚拟机厂商的实现。  
严格来说是静态常量池和运行时常量池，静态常量池是存放字符串字面量、符号引用以及类和方法的信息，而运行时常量池存放的是运行时一些直接引  
用。  
运行时常量池是在类加载完成之后，将静态常量池中的符号引用值转存到运行时常量池中，类在解析之后，将符号引用替换成直接引用。  
运行时常量池在 JDK1.7 版本之后，就移到堆内存中了，这里指的是物理空间，而逻辑上还是属于方法区（方法区是逻辑分区）。  
  
## 版本变化  
1.8前：  
![](https://user-gold-cdn.xitu.io/2019/12/15/16f0813a8e3a938a?imageslims)  
1.8后：  
![](https://user-gold-cdn.xitu.io/2019/12/15/16f0813a8ff2ac5e?imageslim)  
  
# 常见的 Java 内存溢出有以下几种  
- java.lang.OutOfMemoryError: Java heap space —-JVM Heap（堆）溢出  
假如在创建新的对象时, 堆内存中的空间不足以存放新创建的对象, 就会引发java.lang.OutOfMemoryError: Java heap space 错误。(和本机物理内存无关，和你配置的对内存大小有关！)  
JVM 在启动的时候会自动设置 JVM Heap 的值，其初始空间（即-Xms）是物理内存的1/64，最大空间（-Xmx）不可超过物理内存。  
解决方法：利用 JVM提供的 -Xms -Xmx 等选项，手动设置 JVM Heap（堆）的大小。    
  
- java.lang.OutOfMemoryError: GC Overhead Limit Exceeded   
当JVM花太多时间执行垃圾回收并且只能回收很少的堆空间时，就会发生此错误。  
默认情况下，如果Java进程花费98%以上的时间执行GC，并且每次只有不到2%的堆被恢复，则JVM抛出此错误。换句话说，这意味着我们的应用程序几乎耗尽了所有可用内存，垃圾收集器花了太长时间试图清理它，并多次失败。  
[解决方案](https://blog.csdn.net/github_32521685/article/details/89953796)  
  
  
- java.lang.OutOfMemoryError: PermGen space  —- PermGen space 溢出。  
即持久代(Permanent Generation)的内存溢出，jdk8已经没有了。  
这块内存主要是被 JVM 存放Class 和 Meta 信息的，Class 在被 Load 的时候被放入该区域，它和存放 Instance 的 Heap 区域不同，sun 的 GC 不会在主程序运行期对 PermGen space 进行清理，所以如果你的 APP 会载入很多 CLASS 的话，就很可能出现 PermGen space 溢出。  
这种错误常见在web服务器对JSP进行pre compile的时候。？  
解决方法： 手动设置 MaxPermSize 大小  
[java.lang.OutOfMemoryError: PermGen space有效解决方法](https://blog.csdn.net/yufang131/article/details/80747564)  
  
- java.lang.StackOverflowError   —- 栈溢出  
**每个方法调用会在栈上划出一块作为栈帧。一个方法从开始执行到结束的过程，就是一个栈帧在虚拟机栈中入栈到出栈的过程。**  
调用函数的 “层”太多了，栈空间装不下无限进入的栈帧了，以致于把栈区溢出了。  
通常来讲，一般栈区远远小于堆区的，因为函数调用过程往往不会多于上千层，而即便每个函数调用需要 1K 的空间（这个大约相当于在一个 C 函数内声明了 256 个 int 类型的变量），那么栈区也不过是需要 1MB 的空间。通常栈的大小是 1－2MB 的。  
  
  
## 怎么快速定位问题  
`参数-XX:+HeapDumpOnOutOfMemoryError可让虚拟机在出现内存溢出是Dump出当前的内存堆转储快照以便时候进行分析`  
诊断Java中的内存泄露  
https://cloud.tencent.com/developer/article/1342372  
工具使用 https://blog.csdn.net/sinat_33760891/article/details/82425621  
  
待阅读：  
https://juejin.im/post/5ea2995851882573c04cef4e  
https://juejin.im/post/5df5c76ee51d45581634f256#heading-29  
https://www.jianshu.com/p/4455e4234d5c  
http://www.spring4all.com/article/18645  
https://developer.aliyun.com/article/681512  
https://www.infoq.cn/article/rhW0p6VHzOZ1swcd86rW  
https://www.yisu.com/zixun/91929.html  
https://bbs.huaweicloud.com/blogs/136192  
https://juejin.im/post/59da10a76fb9a00a664a5e6e  
https://juejin.im/post/5f1e3152f265da22b252a885