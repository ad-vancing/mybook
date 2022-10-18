# mr流程
![](https://img-blog.csdnimg.cn/c3e2bcd701c0404ca4ad134e405d50a3.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ze35Ze355qE54m5TWFu,size_20,color_FFFFFF,t_70,g_se,x_16)

https://blog.csdn.net/Shockang/article/details/117970151

https://segmentfault.com/a/1190000019114235

调优：https://blog.csdn.net/lihuazaizheli/article/details/107674269

![](https://segmentfault.com/img/bVbs4c2/view)
1. InputFormat 文件输入：分片（分为数据块 128M）、格式化（格式化为键值对<key,value>形式的数据，其中， key 代表偏移量， value 代表每一行内容）
2. map(每个键值对都会调用一次 map 函数，map task 数量由数据块决定)
3. map shuffle
   1. OutputCollector 将中间结果写入环形缓冲区
   4. 分区（根据 reduce task 数量）
   4. 根据 key 排序（快排） 
   2. 达到缓冲区大小的 80 %时排序数据溢写文件，
   2. 多个溢写文件 merge 合并（归并排序）
   4. Combiner(局部 value 的合并) 可选
   5. Compress 可选 
4. reduce shuffle
   1. reduce task 拉取数据并 merge，形成一个 reduce task 的输入文件
   2. 按key进行排序、merge （归并排序）
5. reduce
   1. GroupingComparator 对 reduce 输入文件分组——合并对应单个Key值的键值对(排序？)，每次取出一组 (k，list(v)) 调用 reduce 方法
6. OutputFormat 结果输出  

![](https://img-blog.csdn.net/201805211022156?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Zhbnhpbl9p/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 

![](https://img-blog.csdnimg.cn/img_convert/22f9279adf4d5ef17bf98066447ed686.png)


#总共可能发生4次排序过程：
1. Map阶段
- 环形缓冲区：当缓冲区的数据达到阈值后，对缓冲区数据进行一次快速排序，再一些到磁盘。排序手段：快速排序（会手写）
- 溢写到磁盘中：当数据处理完毕后，所有文件进行归并排序。排序手段：分区归并排序（会手写）
2. Reduce阶段
- 按照指定分区读取到reduce缓冲中（不够则落盘）：磁盘上文件数据达到一定阈值，进行一次归并排序以生成更大的文件。排序手段：归并排序
- Reduce task前分组排序：当所有文件拷贝完毕后，Reduce Task统一对内存和磁盘上所有数据进行一次归并排序。
