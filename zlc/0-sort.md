十大排序算法  
- 冒泡排序（Bubble Sort）
- 插入排序（Insertion Sort）
- 希尔排序（Shell Sort）
- 选择排序（Selection Sort）
- 快速排序（Quick Sort）
- 归并排序（Merge Sort）
- 堆排序（Heap Sort）
- 计数排序（Counting Sort）
- 桶排序（Bucket Sort）
- 基数排序（Radix Sort）

https://blog.csdn.net/zmd_23/article/details/108791825

https://www.cnblogs.com/cashew/p/10512279.html

各个排序算法随着数据集的增大，时间消化程度
![图](https://img-blog.csdn.net/20160225154019089?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

# 算法选择
1. 数据规模  
规模小时，直接插入排序或冒泡排序。
2. 数据类型  
全是正数，桶排序。
3. 数据已有的顺序  
大部分排好了的，不选快排。

# Collections.sort方法使用的是哪种排序方法
调用了Arrays.sort  
Arrays.sort()并不是只有快排，他是根据数据量选择排序算法，源码里还有timsort，而且他的快排是双轴快排


Integer.compare(a, b)!

# TimSort的排序法，也就是增强型的归并排序法
https://sikasjc.github.io/2018/07/25/timsort/

# Redis的 SortedSet 排序set怎么实现

# 快排
https://www.runoob.com/w3cnote/quick-sort-2.html  

思路：  
1、选择第一个数为p，称为 "基准"（pivot）；    
2、指针i一步一步从左往右寻找大于基数p的数字，指针j从右往左寻找小于基数p的数字，i、j都找到后将两个位置的数字进行交换，然后继续前进比较、交换，直到i>=j结束循环，然后将基准数 p和i(或j)位置的数进行交换，即完成一趟快排，这个称为分区（partition）操作；  
此时数组被划分为小于基数p、基数p、大于基数p的三部分；  
3、**递归地（recursive）** 把小于基数p的子数列和大于基数p的子数列按上面的步骤排序，直到不能再递归（不满足 i < j）。  

## 性能
快速排序是在冒泡排序的基础上改进而来的，冒泡排序每次只能交换相邻的两个元素，而快速排序是跳跃式的交换，交换的距离很大，因此总的比较和交换次数少了很多，速度也快了不少。
空间复杂度为 O(logn)。
时间复杂度是 O(nlogn)，最差情况下算法的时间复杂度为O(N^2)。
是一个不稳定的算法，在经过排序之后，可能会对相同值的元素的相对位置造成改变。

快速排序基本上被认为是相同数量级的所有排序算法中，平均性能最好的。

## 快排的思路解决其他问题
https://blog.csdn.net/z275598733/article/details/101459629


# 归并排序 MERGE-SORT
K-way merge 多路归并  
从2路到多路（k路），增大k可以减少外存信息读写时间。

https://www.runoob.com/w3cnote/merge-sort.html

![图](https://ask.qcloudimg.com/http-save/yehe-2890902/vzanio11bs.png?imageView2/2/w/1620)

速度仅次于快排，内存少的时候使用，可以进行并行计算的时候使用。  
1、选择相邻两个数组成一个有序序列。  
2、选择相邻的两个有序序列组成一个有序序列。  
3、重复第二步，直到全部组成一个有序序列。  

随k增而增因此内部归并时间随k增长而增长了，抵消了外存读写减少的时间，由此引出了“败者树”tree of loser的使用。

## 归并排序的时间复杂度
归并排序的最好、最坏和平均时间复杂度都是O(nlogn)，而空间复杂度是O(n)，比较次数介于(nlogn)/2和(nlogn)-n+1，赋值操作的次数是(2nlogn)。  
因此可以看出，归并排序算法比较占用内存，但却是效率高且稳定的排序算法。

# 外排序 External sort
能够处理极大量数据的排序算法。

采用的是一种“排序-归并”的策略。

在排序阶段，先读入能放在内存中的数据量，将其排序输出到一个临时文件，依此进行，将待排序数据组织为多个有序的临时文件。尔后在归并阶段将这些临时文件组合为一个大的有序文件，也即排序结果。

# 线性时间复杂度(O(n))的排序算法
计数排序适用于小范围的整数型元素的数组排序.

基数排序适用于整数型元素, 不怕数值范围太大, 这点要比计数排序强.

桶排序可以用在浮点型元素(当然, 也可以用于整数型元素).

## 桶排序（bucket sort）
核心思想是将要排序的数据分到几个有序的桶里(范围)，每个桶里的数据再单独进行排序，桶内排完序之后，再把每个桶里面的数据按照顺序依次取出，组成的序列就是有序的

## 计数排序（Counting Sort）
[参考](https://www.cnblogs.com/linklate/p/15182542.html)

计数排序其实是桶排序的一种特殊情况。

可以把数据划分为k个桶，每个桶内的数据值都是相同的，省掉了桶内排序的时间。

eg:考生的满分是900，最小值为0分，数据的范围很小，可以分成901个桶，对应分数从0到900，根据考生的成绩，将上百万考生划分到这901个桶，桶内的数据都是分数相同的考生，所以并不需要再进行排序，只需要依次扫描每个桶，将桶内的考生依次输出到一个数组中，实现了上百万考生的排序，因为只涉及扫描遍历操作，所以时间复杂度是O(N)

## 基数排序（Radix Sort）
根据位数比较来排序  
https://blog.csdn.net/qq_43665697/article/details/99425086

荷兰国旗问题
https://www.jianshu.com/p/356604b8903f

# 场景
## 百万数据排序
- 情况一：
排序值范围小，如[0,200]，可以遍历这100W条数据，划分到200个桶内，然后依次顺序遍历这200个桶中的元素，这样得到了100W条数据的排序。
- 情况二：
排序值范围大，如1-1亿，可以考虑基数排序。

一百万个数求最大100个数，和最小100个数
https://blog.csdn.net/cslbupt/article/details/65935577

# 堆&堆排序
一般用数组来表示堆，下标为 i 的结点的父结点下标为(i-1)/2；其左右子结点分别为 (2i + 1)、(2i + 2)  
https://zhuanlan.zhihu.com/p/124885051  
[有个视频1](https://www.cs.usfca.edu/~galles/visualization/HeapSort.html)  
[有个视频2](https://vdn.vzuu.com/SD/3bb38dfe-236a-11eb-8039-a6caf32b14c9.mp4?disable_local_cache=1&bu=078babd7&c=avc.0.0&f=mp4&expiration=1668442767&auth_key=1668442767-0-0-7a62b65a67907eabdd5598dc10d3b66f&v=ali&pu=078babd7)

直接选择排序中，为了从R[1…n]中选择最大记录，需比较n-1次，然后从R[1…n-2]中选择最大记录需比较n-2次。  
事实上这n-2次比较中有很多已经在前面的n-1次比较中已经做过，而树形选择排序恰好利用树形的特点保存了部分前面的比较结果，因此可以减少比较次数。  
对于n个关键字序列，最坏情况下每个节点需比较log2(n)次，因此其最坏情况下时间复杂度为nlogn。

堆排序为不稳定排序，不适合记录较少的排序。
