# ConcurrentHashMap 怎么保证线程安全

在JDK8以前，ConcurrentHashMap都是基于Segment分段锁来实现的，在JDK8以后，就换成synchronized和CAS这套实现机制了。

# JDK7 的 ConcurrentHashMap 原理？
ConcurrentHashMap 用于解决 HashMap 的线程不安全和 HashTable 的并发效率低，HashTable 之所以效率低是因为所有线程都必须竞争同一把锁，假如容器里有多把锁，每一把锁用于锁容器的部分数据，那么多线程访问容器不同数据段的数据时，线程间就不会存在锁竞争，从而有效提高并发效率，这就是 ConcurrentHashMap 的锁分段技术。首先将数据分成 Segment 数据段，然后给每一个数据段配一把锁，当一个线程占用锁访问其中一个段的数据时，其他段的数据也能被其他线程访问。

get 实现简单高效，先经过一次再散列，再用这个散列值通过散列运算定位到 Segment，最后通过散列算法定位到元素。get 的高效在于不需要加锁，除非读到空值才会加锁重读。get 方法中将共享变量定义为 volatile，在 get 操作里只需要读所以不用加锁。

put 必须加锁，首先定位到 Segment，然后进行插入操作，第一步判断是否需要对 Segment 里的 HashEntry 数组进行扩容，第二步定位添加元素的位置，然后将其放入数组。

size 操作用于统计元素的数量，必须统计每个 Segment 的大小然后求和，在统计结果累加的过程中，之前累加过的 count 变化几率很小，因此先尝试两次通过不加锁的方式统计结果，如果统计过程中容器大小发生了变化，再加锁统计所有 Segment 大小。判断容器是否发生变化根据 modCount 确定。

![](https://img-blog.csdnimg.cn/img_convert/4d500238dcce0acb37ea591792e11d81.png)
# JDK8 的 ConcurrentHashMap 原理？
CAS + Synchronized  
主要对 JDK7 做了三点改造：① 取消分段锁机制，进一步降低冲突概率。② 引入红黑树结构，同一个哈希槽上的元素个数超过一定阈值后，单向链表改为红黑树结构。③ 使用了更加优化的方式统计集合内的元素数量。具体优化表现在：在 put、resize 和 size 方法中设计元素总数的更新和计算都避免了锁，使用 CAS 代替。

get 同样不需要同步，put 操作时如果没有出现哈希冲突，就使用 CAS 添加元素，否则使用 synchronized 加锁添加元素。

当某个槽内的元素个数达到 7 且 table 容量不小于 64 时，链表转为红黑树。当某个槽内的元素减少到 6 时，由红黑树重新转为链表。在转化过程中，使用同步块锁住当前槽的首元素，防止其他线程对当前槽进行增删改操作，转化完成后利用 CAS 替换原有链表。由于 TreeNode 节点也存储了 next 引用，因此红黑树转为链表很简单，只需从 first 元素开始遍历所有节点，并把节点从 TreeNode 转为 Node 类型即可，当构造好新链表后同样用 CAS 替换红黑树。
![](https://img-blog.csdnimg.cn/img_convert/85ef04998510aa9e1b34329c03d8d958.png)
# ConcurrenHashMap，要讲出 1.7 和 1.8 的区别
1、JDK1.8 中降低锁的粒度。JDK1.7 版本锁的粒度是基于 Segment 的，包含多个节点（HashEntry），而 JDK1.8 锁的粒度就是单节点（Node）。

2、JDK1.8 版本的数据结构变得更加简单，使得操作也更加清晰流畅，因为已经使用 synchronized 来进行同步，所以不需要分段锁的概念，也就不需要 Segment 这种数据结构了，当前还保留仅为了兼容。

3、JDK1.8 使用红黑树来优化链表，跟 HashMap 一样，优化了极端情况下，链表过长带来的性能问题。

4、JDK1.8 使用内置锁 synchronized 来代替重入锁 ReentrantLock，synchronized 是官方一直在不断优化的，现在性能已经比较可观，也是官方推荐使用的加锁方式。



（1）ConcurrentHashMap的锁分段技术

（2）ConcurrentHashMap的读是否要加锁，为什么

（3）ConcurrentHashMap的迭代器是强一致性的迭代器还是弱一致性的迭代器