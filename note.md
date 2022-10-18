![](file:///Users/guanliyuan/Downloads/17221e53888f0ad6_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0.awebp)

# 防止数据重复提交
https://juejin.cn/post/6850418120985837575
总体思路：方法执行之前，先判断此业务是否已经执行过，如果执行过则不再执行，否则就正常执行。

实现1:将请求的业务 ID 存储在 HashMap 中缓存。
存在的问题：HashMap 是无限增长的，因此它会占用越来越多的内存，并且随着 HashMap 数量的增加查找的速度也会降低，所以我们需要实现一个可以自动“清除”过期数据的实现方案。

优化1.1:使用数组加下标计数器（reqCacheCounter）的方式，实现了固定数组的循环存储。当数组存储到最后一位时，将数组的存储下标设置 0，再从头开始存储数据。
优化1.2:使用单例中著名的 DCL（Double Checked Locking，双重检测锁）来优化代码的执行效率，适用于重复提交频繁比较高的业务场景，对于相反的业务场景下 DCL 并不适用。
优化1.3:Apache 为我们提供了一个 commons-collections 的框架，里面有一个非常好用的数据结构 LRUMap （ Least Recently Used ）可以保存指定数量的固定的数据，并且它会按照 LRU 算法，帮你清除最不常用的数据。


