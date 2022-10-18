AbstractQueuedSynchronizer

抽象的队列式同步器，是一种基于状态（state）的链表管理方式。state 是用CAS去修改的。
它是 java.util.concurrent 包中最重要的基石，要学习想学习 java.util.concurrent 包里的内容这个类是关键。 
ReentrantLock、CountDownLatcher、Semaphore 实现的原理就是基于AQS。

# 原理
以ReentrantLock为例，原子变量state初始化为0，表示未锁定状态。A线程lock()时，会调用tryAcquire()独占该锁并将state+1。此后，其他线程再tryAcquire()时就会失败，直到A线程unlock()到state=0（即释放锁）为止，其它线程才有机会获取该锁。当然，释放锁之前，A线程自己是可以重复获取此锁的（state会累加），这就是可重入的概念。但要注意，获取多少次就要释放多么次，这样才能保证state是能回到零态的。

再以CountDownLatch以例，任务分为N个子线程去执行，state也初始化为N（注意N要与线程个数一致）。这N个子线程是并行执行的，每个子线程执行完后countDown()一次，state会CAS减1。等到所有子线程都执行完后(即state=0)，会unpark()主调用线程，然后主调用线程就会从await()函数返回，继续后余动作。

state的访问方式有三种:
getState()
setState()
compareAndSetState()
其中compareAndSetState的实现依赖于Unsafe的compareAndSwapInt()方法：
```
return unsafe.compareAndSwapInt(this, stateOffset, expect, update);
```

自定义同步器要么是独占方法，要么是共享方式，他们也只需实现tryAcquire-tryRelease、tryAcquireShared-tryReleaseShared中的一种即可。但AQS也支持自定义同步器同时实现独占和共享两种方式，如ReentrantReadWriteLock。
https://www.jianshu.com/p/da9d051dcc3d

# 释放锁以及添加线程对于队列的变化
https://blog.csdn.net/weixin_45596022/article/details/113817683?utm_medium=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~Rate-1-113817683-blog-null.pc_404_mixedpudn&depth_1-utm_source=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~Rate-1-113817683-blog-null.pc_404_mixedpud

源码分析：https://www.cnblogs.com/waterystone/p/4920797.html

# 面试题
https://blog.csdn.net/Aria_Miazzy/article/details/104385317
