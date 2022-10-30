# hash
“散列”、“哈希”，把任意长度的输入，通过散列算法，变换成固定长度的输出，该输出就是散列值。  
这种转换是一种压缩映射，也就是，散列值的空间通常远小于输入的空间，不同的输入可能会散列成相同的输出，所以不可能从散列值来唯一的确定输入值。  
简单的说就是一种将任意长度的消息压缩到某一固定长度的消息摘要的函数。

**根据同一散列函数计算出的散列值如果不同，那么输入值肯定也不同。但是，根据同一散列函数计算出的散列值如果相同，输入值不一定相同。**  
两个不同的输入值，根据同一散列函数计算出的散列值相同的现象叫做碰撞。

## 常见的Hash函数有以下几个
直接定址法：直接以关键字k或者k加上某个常数（k+c）作为哈希地址。  
数字分析法：提取关键字中取值比较均匀的数字作为哈希地址。  
除留余数法：用关键字k除以某个不大于哈希表长度m的数p，将所得余数作为哈希表地址。
分段叠加法：按照哈希表地址位数将关键字分成位数相等的几部分，其中最后一部分可以比较短。然后将这几部分相加，舍弃最高进位后的结果就是该关键字的哈希地址。
平方取中法：如果关键字各个部分分布都不均匀的话，可以先求出它的平方值，然后按照需求取中间的几位作为哈希地址。
伪随机数法：采用一个伪随机数当作哈希函数。

# java7版本的 HashMap底层数据结构和原理
[主要抄这里的，源码分析看看](https://cloud.tencent.com/developer/article/1337158)
HashMap是Java中的一个容器，继承自AbstractMap抽象类，实现了Map接口。  
它用散列存储的方式保存kay-value键值对，因此其不支持数据保存的顺序。  

HashMap中默认有一个长度为16的数组，叫做table，table的索引在逻辑上叫做“桶”(bucket)，它存储了链表的头节点，链表中的每个节点，就是哈希表中的每个元素。

```
HashMap数组：transient Entry[] table
数组默认长度：static final int DEFAULT_INITIAL_CAPACITY = 1 << 4
数组最大长度：static final int MAXIMUM_CAPACITY = 1 << 30（原因是2的31次方就超过Integer.MAX_VALUE(2147483647)了（也就是2^31-1），而数组的长度都必须是2的次方）
默认加载因子：static final float DEFAULT_LOAD_FACTOR = 0.75f（当长度大于3/4的时候就会扩容）
扩容临界值：private int threshold；（threshold=capcity*loadFactor）

```

其中Entry<K,V>就是HashMap中数组的每一个元素，就是一个链表的头节点，属性有：

```
        final K key;
        V value;
        Entry<K,V> next;
        int hash;

```

next指向是链表的下一个节点，hash就是该key的hashCode。

## 初始化

当执行`Map map=new HashMap();` 时，不管指定了多少INITIAL_CAPACITY，map先定义了一个类型为Entry的空数组 EMPTY_TABLE。

## put元素 `put(K key, V value)`

向HashMap中put元素的时候，比如执行`map.put(“key1”,”value1”);`

**第一次put元素时，判断如果table为空数组，则通过`inflateTable(threshold)`实例化。`roundUpToPowerOf2(toSize)`计算出大于等于toSize（默认是16，或指定的INITIAL_CAPACITY）且最接近2的幂次方的数，来作为数组的长度capacity**

> ps：1.8中，HashMap初始化这个容量的时机不同。
jdk1.8中，在调用HashMap的构造函数定义HashMap的时候，就会进行容量的设定。
而在Jdk 1.7中，要等到第一次put操作时才进行这一操作。
> 

> Q:第一个大于该数值的2的幂的计算原理
> 

> Q：在阿里巴巴Java开发手册中，阿里工程师对于初始化hashmap的容量的建议是：INITIAL_CAPACITY =（要存储的元素数/0.75）+ 1
当我们new hashmap并且指定初始化容量capacity时，jdk会帮我们取第一个大于capacity的2次幂(目的是？提高hash的效率？)。
5->8 10->16 90->128
但是，hashmap在我们存放的数据大于初始化容量*负载因子（默认0.75）时就会自动扩容，自动扩容是非常消耗性能的。因为元素要重新hash分配。
那么当我们生成了一个7容量的map，jdk会生成一个8容量的map，那么存放到8 * 0.75 = 6个元素时就会扩容了，跟我们预想放7个有偏差，所以阿里就推出了这个建议。
这样我们想放7个元素，就设置 7 / 0.75 + 1 = 10，经过jdk会生成16的容量，这样我们存放7个元素就不会因为扩容而损失性能了，当然会消耗一部分内存。
> 

### put数据的步骤

1. 先计算出key的hashCode ，得到一个整型的数;

> Q： key 为 null的处理
参考putForNullKey()方法
a) HashMap 中，是允许 key、value 都为 null 的，且 key 为 null 只存一份，多次存储会将就 value 值覆盖；
b)key 为 null 的存储位置，都统一放在下标为0的 bucket，即：table[0]位置的链表；
c)找到数组下标为0的链表，先遍历该链表，找到key是null的节点，用新的value替换旧的value；如果没有找到key是null的节点，就直接在数组下标为0的链表上添加该元素（键值对）。
> 
1. 根据hashCode来计算存放该键值对（Entry）对应的bucket的下标值，即数组table的下标;

> Q：怎么计算hash值？
参考hash(Object k)
如果key为String，主要是sun.misc.Hashing.stringHash32((String) k)；否则对hashSeed和key的hashCode进行异或运算，再进行无符号右移、异或计算。
> 

> ps：1.8中，直接(h = key.hashCode()) ^ (h >>> 16)得到。
> 

> Q：怎么根据hash值计算数组下标值？
参考indexFor(int h, int length)用hash值和数组长度-1进行与运算
其实，只要保证length的长度是2^n的话，这样做就是对数组长度取模%求余。用位运算(&)来代替取模运算(%)，最主要的考虑就是效率，位运算(&)效率要比代替取模运算(%)高很多，因为位运算直接对内存数据进行操作，不需要转成十进制，因此处理速度非常快。
eg：  length =4 ：13%4=13&3=1     length =5 ：13%5=3  13&4=4
> 

### put数据的过程

找到数组下标后，遍历数组下标对应空间存储的链表，判断链表里是否已经存在与新元素key值相等的节点。

> Q：如何判断2个key是否相同
if (e.hash == hash && ((k = e.key) == key || key.equals(k)))
先判断hash值是否相等，再判断要么内存地址相等，要么逻辑上相等，两者有一个满足即可。
> 

> Q：一个普通的对象，能够作为HashMap的key么？
对于 HashMap 中 key 的类型，必须满足以下的条件：若两个对象逻辑相等，那么他们的 hashCode 一定相等，反之却不一定成立。
我们可以将逻辑的相等定义为两个对象的内存地址相同，也可以定义为对象的某个域值相等。
自定义两个对象的逻辑相等，可通过重写Object类的equals()方法来实现。
同时，也需要重写hashCode方法。
如果忘记重写的话，会怎么样？
比如：String str1 = "abc"; String str2 = new String("abc");
假设String类没有重写equals()方法和hashCode方法，那么str1、str2当做key做 put 操作时，就会被分配到不同的 bucket 上，导致的最直接后果就是会存储两份。
间接的后果那就更多了，比如：String str3 = new StringBuilder("ab").append("c").toString();，使用str3对象执行get(str3)操作时，可能获取不到值，
更进一步的后果就是这部分无法触达的对象无法回收，导致内存泄漏。
> 

3.1 如果已经存在key，就用新的value覆盖旧的value；

3.2 如果不存在key（包含了这个位置没有链表节点的情况），会调用`addEntry(hash,key,value,数组下标)`创建一个新节点元素来保存元素（使用`头插法`做链表插入）。
**创建新节点前，会判断是否需要扩容，如果需要，会先扩容，再创建**

> Q：什么情况下会扩容
两个条件
1、HashMap中目前存储元素的个数size，大于等于扩容临界值（数组长度*加载因子）
2、当前位置存储内容不为空时
> 

> Q： **为什么需要使用加载因子?**
因为如果填充比很大，说明利用的空间很多，如果一直不进行扩容的话，链表就会越来越长，这样查找的效率很低，因为链表的长度很大（当然最新版本使用了红黑树后会改进很多），扩容之后，将原来链表数组的每一个链表分成奇偶两个子链表分别挂在新链表数组的散列位置，这样就减少了每个链表的长度，增加查找效率。
> 

HashMap本来是以空间换时间，所以填充比没必要太大。但是填充比太小又会导致空间浪费。如果关注内存，填充比可以稍大，如果主要关注查找性能，填充比可以稍小。

> Q：怎么扩容
resize(2 * table.length) 扩大后的容量为数组长度的2倍。
扩容的核心逻辑在resize方法调用的transfer方法中，主要就是把原来table中的元素复制到扩容后的newTable中。
需要遍历数组，再遍历链表。
为避免碰撞过多，先决策是否需要对每个 Entry 链表结点重新 hash，然后根据 hash 值计算得到 bucket 下标，然后使用头插法做结点迁移。
> 

> Q：  性能问题
1、性能的体现主要在扩容操作上，扩容时，要遍历HashMap中原来的数组中的元素并重新计算每个元素key的hash值和新数组的位置，相对来说是非常耗时的。所以在初始化HashMap时，可以预估HashMap中会存储多少个元素，来设置HashMap的初始容量和加载因子的值，尽量避免HashMap扩容操作。
2、理想状态下，HashMap中数组的每个位置都只存储一个元素（数组存满，且没有链表）时，查找效率和存储利用率是最高的，因为通过计算key的hash就可以直接定位到数组中的位置，不需要遍历链表，但这只是理想状态，现实操作中一旦出现hash碰撞就会产生链表。
那么如何减少哈希冲突呢？
那么需要key对应的存储位置index尽可能的不同。
首先调用hash函数，将key的hashCode值的低16位于高16位进行异或运算，充分的使用hashCode的32个二进制数据进行运算（int是4个字节），得到变量hash。
> 

## get元素 `get(Object key)`

根据key值获取HashMap中的元素时，比如执行`map.get(“key1”);`

> ps：如果key值为null，直接调用getForNullKey去数组下标为0的链表上遍历key值为null的节点元素并返回value值
> 

### getEntry(key1)方法获得value值的过程

如果size==0即HashMap中没有元素，直接返回null
否则：

1.先计算`hash(key)`得hashCode；

2.根据hashCode找出该元素存储链表所在的数组下标`indexFor(hash, table.length)`

3、遍历链表，通过`if (e.hash == hash && ((k = e.key) == key || (key != null && key.equals(k)))`找到key值相同的元素，返回 Entry e 最后得到value。

## 遍历HashMap有哪几种方法

1.Iterator 迭代器
2.testMap.entrySet()得到Entry集合再遍历，其底层还是使用的是 testMap.entrySet().iterator()
3.foreach 方式，其内部是使用了方式二的处理方式
4.通过 key 的 set 集合遍历

从性能方面考虑，若需同时使用 key 和 value，推荐使用方式 1或方式 2，若单纯只是使用 key，推荐使用方式 4。
不推荐使用方式 3，因为会新增二次查询（通过 key 再一次在 Map 中查找 value）。
另外，使用方式 1时，还可以做 remove 操作

# java8中HashMap的改进

[这里这不错](https://blog.csdn.net/zxt0601/article/details/77413921)
1、Entry<K,V>被  Node<K,V>哈希桶代替（换了一个马甲）。

2、`hash(key)`求key的hash值，并不仅仅只是key对象的hashCode()方法的返回值，还会经过**扰动函数**的扰动，以使hash值更加均衡。（调用Key的hashCode方法获取hashCode值，并将该值的高16位和低16位进行异或运算 `(h = key.hashCode()) ^ (h >>> 16)`）

> 求桶的下标时，取余是通过与操作完成的，而且会忽略hash值的高位，只有hash值的低位参加运算，不同的hash值，得到的index相同的情况的几率是挺大的，这种情况称之为hash碰撞。
扰动函数就是为了解决hash碰撞的。它会综合hash值高位和低位的特征，并存放在低位，因此在与运算时，相当于高低位一起参与了运算，以减少hash碰撞的概率。（在JDK8之前，扰动函数会扰动四次，JDK8简化了这个操作）
> 

3、链表使用尾插法
新放入的 Entry 是放到链的尾部；
可避免多线程环境下导致的死循环（多个线程分别做扩容操作时 可能会形成环状链表）。
JDK7里resize()时使用了头插法，将原本的顺序做了反转，留下了死循环的机会。

4、链表与红黑树互相转换。
put方法时，当链表长度达到`TREEIFY_THRESHOLD` 8，会转化成红黑树（先插入到末尾再判断变不变树），以提升它的查询、插入效率；
在红黑树的结点个数小于`UNTREEIFY_THRESHOLD` 6个时，会将红黑树转化为链表结构；
若为红黑树，则在树中通过key.equals(k)查找，O(logn)；
若为链表，则在链表中通过key.equals(k)查找，O(n)。

5、扩容，迁移数据逻辑

> hash()算法上有修改，从而改进了resize()方法里重新确定结点在新数组中的存储位置的逻辑。
扩容时，重新创建新的容量翻倍的数组，由于数组的长度tab.length发生变化，hash&(tab.length-1)得到的值发生变化。
例如数组大小从16扩容到32时，tab.length-1是31，二进制表示是11111。oldCap=16即就数组原长度 10000。
重新确定结点的位置时，hash变量在进行与运算时，若hash的第5位二进制是0（(e.hash & oldCap) == 0），则位置不变；
若第5位二进制是1（(e.hash & oldCap) != 0），则数组存放位置增加16，刚好是旧数组的大小。
所以结点在扩容后的新数组中的位置只有两种，原下标位置或原下标+旧数组的大小。
> 

> HashMap的源码中，充斥个各种位运算代替常规运算的地方，以提升效率：
> 
- 与运算替代模运算。用 hash & (table.length-1) 替代 hash % (table.length)
- 用if ((e.hash & oldCap) == 0)判断扩容后，节点e处于低区还是高区。

```
...
// 前面已经做了第 1 步的长度拓展，我们主要分析第 2 步的操作：如何迁移数据
table = newTab;
if (oldTab != null) {
    // 循环遍历哈希 table 的每个不为 null 的 bucket
    // 注意，这里是"++j"，略过了 oldTab[0]的处理
    for (int j = 0; j < oldCap; ++j) {
        Node<K,V> e;
        if ((e = oldTab[j]) != null) {
            oldTab[j] = null;
            // 若只有一个结点，则原地存储
            if (e.next == null)
                newTab[e.hash & (newCap - 1)] = e;
            else if (e instanceof TreeNode)
                ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
            else { // preserve order
                // "lo"前缀的代表要在原 bucket 上存储，"hi"前缀的代表要在新的 bucket 上存储
                // loHead 代表是链表的头结点，loTail 代表链表的尾结点
                Node<K,V> loHead = null, loTail = null;
                Node<K,V> hiHead = null, hiTail = null;
                Node<K,V> next;
                do {
                    next = e.next;
                    // 以 oldCap=8 为例，
                    //   0001 1000  e.hash=24
                    // & 0000 1000  oldCap=8
                    // = 0000 1000  --> 不为 0，需要迁移
                    // 这种规律可发现，[oldCap, (2*oldCap-1)]之间的数据，
                    // 以及在此基础上加 n*2*oldCap 的数据，都需要做迁移，剩余的则不用迁移
                    if ((e.hash & oldCap) == 0) {
                        // 这种是有序插入，即依次将原链表的结点追加到当前链表的末尾
                        if (loTail == null)
                            loHead = e;
                        else
                            loTail.next = e;
                        loTail = e;
                    }
                    else {
                        if (hiTail == null)
                            hiHead = e;
                        else
                            hiTail.next = e;
                        hiTail = e;
                    }
                } while ((e = next) != null);
                if (loTail != null) {
                    loTail.next = null;
                    newTab[j] = loHead;
                }
                if (hiTail != null) {
                    hiTail.next = null;
                    // 需要搬迁的结点，新下标为从当前下标往前挪 oldCap 个距离。
                    newTab[j + oldCap] = hiHead;
                }
            }
        }
    }
}

```

6、扩容场景也有点变化

- 场景 1：哈希 table 为 null 或长度为 0；
- 场景 2：Map 中存储的 k-v 对数量超过了阈值threshold；
jdk8是如此，jdk7多一个条件，就是“数组当前位置存储内容不为空”。
- 场景 3：链表中的长度超过了TREEIFY_THRESHOLD 8，但表长度却小于`MIN_TREEIFY_CAPACITY` 64（The smallest table capacity for which bins may be treeified.）。
这是jdk8新增的场景。显然是为了减少哈希冲突。

![]([https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/7/26/17389eb159086f06~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/7/26/17389eb159086f06~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp))

## fail-fast 快速失效策略
在迭代器创建之后，如果从结构上对映射进行修改，除非通过迭代器本身的 remove 方法，其他任何时间任何方式的修改，迭代器都将抛出ConcurrentModificationException。

对于非并发集合，在用迭代器对其迭代时，若有其他线程修改了、增减了集合中的内容，这个迭代会马上感知到，并且立即抛出 ConcurrentModificationException 异常，而不是在迭代完成后或者某些并发的场景才报错。

> 当遇到可能会诱导失败的条件时立即上报错误，快速失效系统往往被设计在立即终止正常操作过程，而不是尝试去继续一个可能会存在错误的过程。再简洁点说，就是尽可能早的发现问题，立即终止当前执行过程，由更高层级的系统来做处理。
> 

变量`modCount`，记录了 map 新增/删除 k-v 对，或者内部结构做了调整的次数，其主要作用，**是对 Map 的iterator()操作做一致性校验，如果在 iterator 操作的过程中，map 的数值有修改，直接抛出`java.util.ConcurrentModificationException`异常。**

在iteators创建完毕后（包括foreach，它底层也是用的迭代器），**通过集合的方法对map的任何结构修改**，都会抛出该异常。
因为HashMap 内部抽象类HashIterator内部利用变量`modCount`，做了修改次数一致性校验，防止在遍历时有并发的修改操作(即使是本线程修改也不行)。

正确的删除 Map 元素的姿势：只有一个，Iteator 的remove()方法。
但也要注意一点，能安全删除，并不代表就是多线程安全的，在多线程并发执行时，若都执行上面的操作，因未设置为同步方法，也可能导致modCount与expectedModCount不一致，从而抛异常ConcurrentModificationException。

一般来说，存在非同步的并发修改时，不可能作出任何的保证。快速失败迭代器只是尽最大努力抛出ConcurrentModificationException。因此，编写依赖于此异常的程序的做法是错误的，正确做法是：迭代器的快速失败行为应该仅用于检测程序错误。

### 实现机制
modCount 修改次数，对List内容的修改都会增加这个值，
在迭代器初始化的过程中会将这个值赋值给迭代器的expectedModCount。

```
    try {
    ....
    if (modCount != expectedModCount)// judge the modCount equals with expectedModCount.
    throw new ConcurrentModificationException();
    ...
    }
```

## 源码分析

get方法无需加锁，由于其中涉及到的共享变量都使用volatile修饰，volatile可以保证内存可见性，所以不会读取到过期数据。

put方法，怎么定位Segment的？
[关于segmentShift和segmentMask](https://www.cnblogs.com/chengxiao/p/6842045.html)

## LinkedHashMap 与 LRUcache

LRU 是 Least Recently Used 的缩写，翻译过来就是“最近最少使用”，也就是说，LRU 缓存把最近最少使用的数据移除，让给最新读取的数据。而往往最常读取的，也是读取次数最多的，所以，利用 LRU 缓存，我们能够提高系统的 performance。

```
import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int CACHE_SIZE;

    /**
     * 传递进来最多能缓存多少数据
     *
     * @param cacheSize 缓存大小
     */
    public LRUCache(int cacheSize) {
        // true 表示让 linkedHashMap 按照访问顺序来进行排序，最近访问的放在头部，最老访问的放在尾部。
        super((int) Math.ceil(cacheSize / 0.75) + 1, 0.75f, true);
        CACHE_SIZE = cacheSize;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        // 当 map中的数据量大于指定的缓存个数的时候，就自动删除最老的数据。
        return size() > CACHE_SIZE;
    }
}

```

# HashMap实现原理

[https://blog.csdn.net/pihailailou/article/details/82053420](https://blog.csdn.net/pihailailou/article/details/82053420)

hashMap我们知道默认初始容量是16，也就是有16个桶，那hashmap是通过什么来计算出put对象的时候该放到哪个桶呢？

[https://blog.csdn.net/qq_33709582/article/details/113337405](https://blog.csdn.net/qq_33709582/article/details/113337405)

- HaspMap扩容是怎样扩容的，为什么都是2的N次幂的大小？
    
    扩容后大小是扩容前的 2 倍；
    
    数据搬迁，从旧 table 迁到扩容后的新 table。 为避免碰撞过多，先决策是否需要对每个 Entry 链表结点重新 hash，然后根据 hash 值计算得到 bucket 下标，然后使用头插法(1.7)做结点迁移。
    
    - 降低发生碰撞的概率，使散列更均匀。
    当哈希表长度为 2 的次幂时，使用“与”运算公式：`h & (length-1)`等同于使用表长度对 hash 值取模，散列更均匀；
    假设 h=5,length=16, 那么 h & length - 1 将得到 5；如果 h=6,length=16, 那么 h & length - 1 将得到 6 ……如果 h=15,length=16, 那么 h & length - 1 将得到 15；但是当 h=16 时 , length=16 时，那么 h & length - 1 将得到 0 了；当 h=17 时 , length=16 时，那么 h & length - 1 将得到 1 了…
    - 表的长度为 2 的次幂，那么(length-1)的二进制最后一位一定是 1，在对 hash 值做“与”运算时，最后一位就可能为 1，也可能为 0，换句话说，取模的结果既有偶数，又有奇数。设想若(length-1)为偶数，那么“与”运算后的值只能是 0，奇数下标的 bucket 就永远散列不到，不仅会浪费一半的空间而且大概率出现哈希冲突。
    - 与运算保证计算得到的索引值总是位于 table 数组的索引之内。
    - 上面都是bb，最重要的是：**可以用位运算替代取余操作，更加高效。**

- HashMap在高并发下如果没有处理线程安全会有怎样的安全隐患，具体表现是什么?
    
    赋值、**扩容时会造成死循环：**
    
    只有 JDK7 及以前的版本会存在死循环现象，在 JDK8 中，resize()方式已经做了调整，使用两队链表，且都是使用的尾插法，及时多线程下，也顶多是从头结点再做一次尾插法，不会造成死循环。而 JDK7 能造成死循环，就是因为 resize()时使用了头插法，将原本的顺序做了反转，才留下了死循环的机会。
    
    [https://juejin.cn/post/6854573219299459086#heading-29](https://juejin.cn/post/6854573219299459086#heading-29)
    
    两个线程执行put()操作、删除操作、修改操作时，可能导致数据覆盖。
    
    最好使用java.util.concurrent.ConcurrentHashMap，相对安全，效率高（同步锁每次只锁一个bucket（数组table的单个元素） ,可以多线程同时读写不同bucket ,也保证了put/get同一个桶的同步）
    

源码分析：

[https://www.cnblogs.com/little-fly/p/7344285.html](https://www.cnblogs.com/little-fly/p/7344285.html)

# 为什么是0.75而不是其他的？
是在时间和空间上权衡的结果。如果值较高，例如1，此时会减少空间开销，但是 hash 冲突的概率会增大，增加查找成本；而如果值较低，例如 0.5 ，此时 hash 冲突会降低，但是有一半的空间会被浪费，所以折衷考虑 0.75 似乎是一个合理的值。
https://joonwhee.blog.csdn.net/article/details/106324537https://joonwhee.blog.csdn.net/article/details/106324537

# 为什么链表转红黑树的阈值是8？
我们平时在进行方案设计时，必须考虑的两个很重要的因素是：时间和空间。对于 HashMap 也是同样的道理，简单来说，阈值为8是在时间和空间上权衡的结果
红黑树节点大小约为链表节点的2倍，在节点太少时，红黑树的查找性能优势并不明显，付出2倍空间的代价作者觉得不值得。

理想情况下，使用随机的哈希码，节点分布在 hash 桶中的频率遵循泊松分布，按照泊松分布的公式计算，链表中节点个数为8时的概率为 0.00000006（就我们这QPS不到10的系统，根本不可能遇到嘛），这个概率足够低了，并且到8个节点时，红黑树的性能优势也会开始展现出来，因此8是一个较合理的数字。


————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/115712641


# 为什么转回链表节点是用的6而不是复用8？
如果我们设置节点多于8个转红黑树，少于8个就马上转链表，当节点个数在8徘徊时，就会频繁进行红黑树和链表的转换，造成性能的损耗。

# 什么时候用红黑树？
对于插入，默认情况下是使用链表节点。当同一个索引位置的节点在新增后达到9个（阈值8）：如果此时数组长度大于等于 64，则会触发链表节点转红黑树节点（treeifyBin）；而如果数组长度小于64，则不会触发链表转红黑树，而是会进行扩容，因为此时的数据量还比较小。


# 扩容（resize）流程
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL3N6X21tYml6X3BuZy9LUlJ4dnFHY2ljWkdMVGljYUxZa3BiTldUZTBkVlRMRncxb0Y0a0FsQU91c0s4SmlhS0Q3VVR5VzR2dE1CTWNCOTVZTXpKODZTdERaNDdkWmpsZXdiSVJFdy8?x-oss-process=image/format,png)

# 插入流程
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL3N6X21tYml6X3BuZy9LUlJ4dnFHY2ljWkdMVGljYUxZa3BiTldUZTBkVlRMRncxVEh1RWdFR2lhVkV3N0JoazBvVWRDVnNnN2dObG5yYUtuemljUEo2M3JiNDlvNFhRTTJWak5pY2ljdy8?x-oss-process=image/format,png)

# JDK 1.8 主要进行了哪些优化？
JDK 1.8 的主要优化刚才我们都聊过了，主要有以下几点：

1）底层数据结构从“数组+链表”改成“数组+链表+红黑树”，主要是优化了 hash 冲突较严重时，链表过长的查找性能：O(n) -> O(logn)。

2）计算 table 初始容量的方式发生了改变，老的方式是从1开始不断向左进行移位运算，直到找到大于等于入参容量的值；新的方式则是通过“5个移位+或等于运算”来计算。
3）优化了 hash 值的计算方式，老的通过一顿瞎JB操作，新的只是简单的让高16位参与了运算。

4）扩容时插入方式从“头插法”改成“尾插法”，避免了并发下的死循环。

5）扩容时计算节点在新表的索引位置方式从“h & (length-1)”改成“hash & oldCap”，性能可能提升不大，但设计更巧妙、更优雅。

# HashMap怎么解决Hash冲突的
拉链法

# 其他解决hash冲突的方法
https://www.cnblogs.com/wuchaodzxx/p/7396599.html
衡量一个哈希函数的好坏的重要指标就是发生碰撞的概率以及发生碰撞的解决方案。
任何哈希函数基本都无法彻底避免碰撞，常见的解决碰撞的方法有以下几种：
1）开放定址法
开放定址法就是一旦发生了冲突，就去寻找下一个空的散列地址，只要散列表足够大，空的散列地址总能找到，并将记录存入。
2）链地址法
将哈希表的每个单元作为链表的头结点，所有哈希地址为i的元素构成一个同义词链表。即发生冲突时就把该关键字链在以该单元为头结点的链表的尾部。
3）再哈希法
当哈希地址发生冲突用其他的函数计算另一个哈希函数地址，直到冲突不再产生为止。
4）建立公共溢出区
将哈希表分为基本表和溢出表两部分，发生冲突的元素都放入溢出表中。


# 1.7源码
https://www.cnblogs.com/owenma/p/8551505.html

# HashTable

从层级结构上看，HashMap、HashTable 有一个共用的Map接口。另外，HashTable 还单独继承了一个抽象类Dictionary；
HashTable 诞生自 JDK1.0，HashMap 从 JDK1.2 之后才有；
初始值和扩容方式不同。HashTable 的初始值为 11，扩容为原大小的2*d+1。容量大小都采用奇数且为素数，且采用取模法，这种方式散列更均匀。但有个缺点就是对素数取模的性能较低（涉及到除法运算），而 HashMap 的长度都是 2 的次幂，设计就较为巧妙，前面章节也提到过，这种方式的取模都是直接做位运算，性能较好。

其他的，HashMap除了允许key和value保存null值和非线程安全外，其他实现几乎和HashTable一致。

> HashTable不允许 value 为 null，若为 null 则直接抛 NPE。对于 key 为 null 时，执行 key.hashCode()时 未做判空操作，也会外抛 NPE。
> 

但是HashTable线程安全的策略就是put 操作、get 操作、remove 操作、equals 操作，都使用了synchronized关键字修饰，这相当于给整个哈希表加了一把大锁，多线程访问时候，只要有一个线程访问或操作该对象，那其他线程只能阻塞，相当于将所有的操作串行化，在竞争激烈的并发场景中性能就会非常差。

> 既然get()方法只是获取数据，并没有修改 Map 的结构和数据，不加不就行了吗？不好意思，不加也不行，别的方法都加，就你不加，会有一种场景，那就是 A 线程在做 put 或 remove 操作时，B 线程、C 线程此时都可以同时执行 get 操作，可能哈希 table 已经被 A 线程改变了，也会带来问题，因此不加也不行。
> 

ConcurrentHashMap和Hashtable主要区别就是围绕着锁的粒度以及如何锁。

# ConcurrentHashMap
https://troywu0.gitbooks.io/spark/content/javacollectionmian_shi_ti.html
HashMap可以使用ConcurrentHashMap代替，ConcurrentHashMap是一个线程安全，更加快速的HashMap。
ConcurrentHashMap线程安全实现方式---分段锁的技术（segment + Lock）。

ConcurrentHashMap 的高并发性主要来自于三个方面：
用分离锁实现多个线程间的更深层次的共享访问。
用 HashEntery 对象的不变性来降低执行读操作的线程在遍历链表期间对加锁的需求。
通过对同一个 Volatile 变量的写 / 读访问，协调不同线程间读 / 写操作的内存可见性。

ConcurrentHashMap将hash表分为16个桶（默认值），诸如get,put,remove等常用操作只锁当前需要用到的桶。试想，原来 只能一个线程进入，现在却能同时16个写线程进入（写线程才需要锁定，而读线程几乎不受限制），并发性的提升是显而易见的。
只有在求size等操作时才需要锁定整个表。

另外，ConcurrentHashMap使用了不同于传统集合的快速失败迭代器————弱一致迭代器。
在这种迭代方式中，当iterator被创建后集合再发生改变就不再是抛出`ConcurrentModificationException`。在改变时new新的数据不影响原有的数据，iterator完成后再将头指针替换为新的数据，这样iterator线程可以使用原来老的数据，而写线程也可以并发的完成改变，这保证了多个线程并发执行的连续性和扩展性，是性能提升的关键。

## 实现原理

[参考](https://www.notion.so/hashmap-a3754617d17e42849f5c4f59c94993af)
ConcurrentHashMap中主要实体类就是三个：ConcurrentHashMap（整个Hash表）,Segment（桶），HashEntry（节点）。一个ConcurrentHashMap维护一个Segment数组（ 默认16 个），一个Segment维护一个HashEntry数组。

Segment继承了可重入锁ReentrantLock，从而使得 Segment 对象可以充当锁的角色。
一个Segment就是一个子哈希表（和HashMap差不多），Segment里维护了一个HashEntry数组，
并发环境下对于不同Segment的数据进行操作是不用考虑锁竞争的。（就按默认的ConcurrentLeve为16来讲，理论上就允许16个线程并发执行）
所以，对于同一个Segment的操作才需考虑线程同步，不同的Segment则无需考虑。

> Segment数组的大小ssize是由concurrentLevel来决定的，但是却不一定等于concurrentLevel，ssize一定是大于或等于concurrentLevel的最小的2的次幂。比如：默认情况下concurrentLevel是16，则ssize为16；若concurrentLevel为14，ssize为16；若concurrentLevel为17，则ssize为32。
Segment的数组大小一定是2的次幂，道理和HashMap的一样。
> 

HashEntry 中，包含了 key 和 value 以及 next 指针（类似于 HashMap 中 Entry），所以 HashEntry 可以构成一个链表。

相当于hashmap数组（Segment）组成了ConcurrentHashMap，而且每个hashmap都有个锁
![](https://wiki.jikexueyuan.com/project/java-collection/images/concurrenthashmap3.jpg)

# LinkedHashMap

如果想要使用有序容器可以使用LinkedHashMap。
LinkedHashMap 是 HashMap 的一个子类，它维护着一个运行于所有条目的双重链接列表。此链接列表定义了迭代顺序，**该迭代顺序可以是插入顺序或者是访问顺序**。
如果指定按访问顺序排序，那么调用get方法后，会将这次访问的元素移至链表尾部，不断访问可以形成按访问顺序排序的链表。

**此实现不是同步的**。如果多个线程同时访问链接的哈希映射，而其中至少一个线程从结构上修改了该映射，则它必须保持外部同步。

## 实现原理

底层使用哈希表与双向链表来保存所有元素。其基本操作与父类 HashMap 相似，它通过重写父类相关的方法，来实现自己的双向链接列表特性。
它重新定义了数组中保存的元素 Entry，该 Entry 除了保存当前对象的引用外，还保存了其上一个元素 before 和下一个元素 after 的引用，从而**在哈希表的基础上又构成了双向链接列表**。

LinkedHashMap 定义了**排序模式 accessOrder**，该属性为 boolean 型变量，对于**访问顺序，为 true；对于插入顺序，则为 false**。
一般情况下，不必指定排序模式，其迭代顺序即为默认为插入顺序。

LinkedHashMap 提供了 removeEldestEntry(Map.Entry<K,V> eldest) 方法。该方法可以提供在每次添加新条目时移除最旧条目的实现程序，默认返回 false，这样，此映射的行为将类似于正常映射，即永远不能移除最旧的元素。


# TreeMap
[https://www.cnblogs.com/skywang12345/p/3310928.html](https://www.cnblogs.com/skywang12345/p/3310928.html)
继承自SortedMap接口。
TreeMap的实现是基于红黑树结构。适用于按自然顺序或自定义顺序遍历键（key）。

> AbstractMap抽象类：覆盖了equals()和hashCode()方法以确保两个相等映射返回相同的哈希码。如果两个映射大小相等、包含同样的键且每个键在这两个映射中对应的值都相同，则这两个映射相等。映射的哈希码是映射元素哈希码的总和，其中每个元素是Map.Entry接口的一个实现。因此，不论映射内部顺序如何，两个相等映射会报告相同的哈希码。
SortedMap接口：它用来保持键的有序顺序。SortedMap接口为映像的视图(子集)，包括两个端点提供了访问方法。除了排序是作用于映射的键以外，处理SortedMap和处理SortedSet一样。添加到SortedMap实现类的元素必须实现Comparable接口，否则您必须给它的构造函数提供一个Comparator接口的实现。TreeMap类是它的唯一一个实现。
> 

## TreeMap中默认是按照升序进行排序的，如何让他降序
通过自定义的比较器来实现
定义一个比较器类，实现Comparator接口，重写compare方法，有两个参数，这两个参数通过调用compareTo进行比较

## 如何决定使用 HashMap 还是 TreeMap
如果你需要得到一个有序的结果时就应该使用TreeMap（因为HashMap中元素的排列顺序是不固定的）。除此之外，由于HashMap有更好的性能，所以大多不需要排序的时候我们会使用HashMap。


