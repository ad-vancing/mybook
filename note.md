![](file:///Users/guanliyuan/Downloads/17221e53888f0ad6_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0.awebp)

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

>以前是以为欧洲人有现代科学的思想，才有了工业革命，其实，是因为他们殖民扩张，需要科技支撑他们的轻工业生产。所以这些问题也需要从场景需求考虑，才能深入理解其本质。

# 大纲
## jse
- [基本数据类型](https://www.cnblogs.com/xiaobingzi/p/9683412.html)

- oop的东西（封装、继承、多态）


- 集合（HashMap源码之类的）
1）它实现了什么接口？
2）有哪些常量？默认值
3）怎么实现key不重复的？
比较器
4）什么情况下会出现快速异常，为什么？怎么解决？
5）怎么保证线程安全？

- jvm

- 值引用，对象引用

- classloader

- 反射

- 设计模式（单例、装饰器、适配器）

## web
- http 请求

- tcp

- 浏览器工作原理

- nio

## db
- 事务

- 调优

- sql编写（去重、连接）

## spring
- mvc原理

- spring ioc&aop

- springboot

- springcloud 微服务

## redis
- 分布式锁

- 原理

- 不弄过滤器

## mq
- 丢消息

## ❓


[想做这种gitbook](https://troywu0.gitbooks.io/spark/content/java%E5%AF%B9%E8%B1%A1%E5%88%9B%E5%BB%BA%E7%9A%84%E8%BF%87%E7%A8%8B.html)

一些问号：
抽象类ClassLoader中，loadClass(String name, boolean resolve)方法里使用了（锁对象的）同步代码快，被实现类重写后，就失效了？

ConcurrentHashMap<String, Object> parallelLockMap;在ClassLoader中是怎么使用的？


# 资料
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


[JavaFamily](https://github.com/AobingJava/JavaFamily)  
https://github.com/rongweihe/CS_Offer

https://github.com/CyC2018/CS-Notes
  
https://github.com/Zeb-D/my-review

https://github.com/ZhongFuCheng3y/athena


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

