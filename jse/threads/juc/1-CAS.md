Compare-and-Swap
https://blog.csdn.net/v123411739/article/details/79561458

https://www.jianshu.com/p/da9d051dcc3d

# 哪些用到cas
AtomicBoolean，AtomicInteger，AtomicLong以及 Lock 相关类等底层就是用 CAS实现的，在一定程度上性能比 synchronized 更高。

# cas 是怎么实现的
CAS底层通过Unsafe类实现原子性操作。
getAndIncrement采用了CAS操作，每次从内存中读取数据然后将此数据和+1后的结果进行CAS操作，如果成功就返回结果，否则重试直到成功为止。而compareAndSet利用JNI来完成CPU指令的操作。
```
public final int getAndIncrement() {  
        for (;;) {  
            int current = get();  
            int next = current + 1;  
            if (compareAndSet(current, next))  
                return current;  
        }  
    }  
 
    public final boolean compareAndSet(int expect, int update) {  
        return unsafe.compareAndSwapInt(this, valueOffset, expect, update);  
    }  
```

https://www.cnblogs.com/mickole/articles/3757278.html


#  悲观锁，乐观锁，优缺点，CAS有什么缺陷，该如何解决。 非阻塞同步
乐观锁持乐观态度，就是假设我的数据不会被意外修改，如果修改了，就放弃，从头再来。悲观锁持悲观态度，就是假设我的数据一定会被意外修改，那干脆直接加锁得了。

Synchronized属于悲观锁，悲观地认为程序中的并发情况严重，所以严防死守。CAS属于乐观锁，它假设所有线程访问共享资源的时候不会出现冲突，既然不会出现冲突自然而然就不会阻塞其他线程的操作。因此，线程就不会出现阻塞停顿的状态。那么，如果出现冲突了怎么办？无锁操作是使用CAS(compare and swap)又叫做比较交换来鉴别线程是否出现冲突，出现冲突就重试当前操作直到没有冲突为止。

在并发很小的情况下，数据被意外修改的概率很低，但是又存在这种可能性，此时就用CAS。

在J.U.C包中利用CAS实现类有很多，可以说是支撑起整个concurrency包的实现，在Lock实现中会有CAS改变state变量，在atomic包中的实现类也几乎都是用CAS实现。

3个基本操作数：内存地址V，预期值O，目前新值N。
更新一个变量的时候，只有当变量的预期值O和内存地址V当中的实际值相同时，才会将内存地址V对应的值修改为N。

>假如一个线程操作数据，干了一半活，累了，想要去休息。（貌似今天的线程体质都不太好）。于是它记录下当前数据的状态（就是数据的值），回家睡觉了。
 醒来后打算继续接着干活，但是又担心数据可能被修改了，于是就把睡觉前保存的数据状态拿出来和现在的数据状态比较一下，如果一样，说明自己在睡觉期间，数据没有被人动过（当然也有可能是先被改成了其它，然后又改回来了，这就是ABA问题了），那就接着继续干。如果不一样，说明数据已经被修改了，那之前做的那些操作其实都白瞎了，就干脆放弃，从头再重新开始处理一遍。

# CAS的问题
## ABA问题 
因为CAS会检查旧值有没有变化，这里存在这样一个有意思的问题。比如一个旧值A变为了成B，然后再变成A，刚好在做CAS时检查发现旧值并没有变化依然为A，但是实际上的确发生了变化。
解决方案可以沿袭数据库中常用的乐观锁方式，添加一个版本号可以解决。原来的变化路径A->B->A就变成了1A->2B->3C。规定只要修改数据，必须使版本号加1。

juc 包提供了一个 AtomicStampedReference，原子更新带有版本号的引用类型，通过控制变量值的版本来解决 ABA 问题。
大部分情况下 ABA 不会影响程序并发的正确性，如果需要解决，传统的互斥同步可能会比原子类更高效。

## 自旋时间过长
使用CAS时非阻塞同步，也就是说不会将线程挂起，会自旋（无非就是一个死循环）进行下一次尝试，如果这里自旋时间过长对性能是很大的消耗。
如果许多线程反复尝试更新某一个变量，却又一直更新不成功，循环往复，会给CPU带来很大的压力。
如果JVM能支持处理器提供的pause指令，那么在效率上会有一定的提升。

##只能保证一个共享变量的原子操作
当对一个共享变量执行操作时CAS能保证其原子性，如果对多个共享变量进行操作,CAS就不能保证其原子性。有一个解决方案是利用对象整合多个共享变量，即一个类中的成员变量就是这几个共享变量。然后将这个对象做CAS操作就可以保证其原子性。
atomic中提供了AtomicReference来保证引用对象之间的原子性。

# 有哪些原子类
java.util.concurrent.atomic 包，这个包中的原子操作类提供了一种用法简单、性能高效、线程安全地更新一个变量的方式。到 JDK 8 该包共有17个类，依据作用分为四种：原子更新基本类型类、原子更新数组类、原子更新引用类以及原子更新字段类，atomic 包里的类基本都是使用 Unsafe 实现的包装类。

AtomicInteger 原子更新整形、 AtomicLong 原子更新长整型、AtomicBoolean 原子更新布尔类型。

AtomicIntegerArray，原子更新整形数组里的元素、 AtomicLongArray 原子更新长整型数组里的元素、 AtomicReferenceArray 原子更新引用类型数组里的元素。

AtomicReference 原子更新引用类型、AtomicMarkableReference 原子更新带有标记位的引用类型，可以绑定一个 boolean 标记、 AtomicStampedReference 原子更新带有版本号的引用类型，关联一个整数值作为版本号，解决 ABA 问题。

AtomicIntegerFieldUpdater 原子更新整形字段的更新器、 AtomicLongFieldUpdater 原子更新长整形字段的更新器AtomicReferenceFieldUpdater 原子更新引用类型字段的更新器。

# AtomicIntger 实现原子更新的原理
