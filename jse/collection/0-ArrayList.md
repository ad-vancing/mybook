https://mp.weixin.qq.com/s/8BRrFzSp0wS9Jo-gB-NCeQ
# ArrayList 是怎么实现的（实现了哪些接口）
- ArrayList 是 List 接口的可变数组的实现`private transient Object[] elementData;`。  
- ArrayList 实现了 RandomAccess 接口，即提供了随机访问功能。RandmoAccess 是 java 中用来被 List 实现，为 List 提供快速访问功能的。在 ArrayList 中，我们即可以通过元素的序号快速获取元素对象；这就是快速随机访问。


# ArrayList 序列化
> 为什么用 transient？
被transient` 修饰的变量不会被序列化。我们知道ArrayList是支持序列化的，这不是前后矛盾吗？
对象的序列化和反序列化是通过调用方法 writeObject() 和 readObject() 完成，我们发现，ArrayList 自己实现这两个方法。
动态扩容意味着什么？
意味着数组的实际大小可能永远无法被填满的，总有多余出来空置的内存空间。比如说，默认的数组大小是 10，当添加第 11 个元素的时候，数组的长度扩容了 1.5 倍，也就是 15，意味着还有 4 个内存空间是闲置的。
假如elementData的长度为10，而其中只有5个元素，那么在序列化的时候只需要存储5个元素，而数组中后面5个元素是不需要存储的。
于是将elementData定义为transient，避免了Java自带的序列化机制，并重写了那两个方法，实现了自己可控制的序列化操作。 

想按照自己的方式序列化，它自己实现了 writeObject() 方法：
LinkedList 在序列化的时候只保留了元素的内容 item，并没有保留元素的前后引用。这样就节省了不少内存空间。
readObject() 方法里，注意 for 循环中的 linkLast() 方法，它可以把链表重新链接起来，这样就恢复了链表序列化之前的顺序。



# 初始值
DEFAULT_CAPACITY = 10;
Object[] elementData;
MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;//容量最大21亿。

# 添加元素流程 
“<要存储元素的数据类型>”中的**数据类型
- 必须是引用数据类型**，不能是基本数据类型！
- **允许元素为null**！
- **允许添加重复元素**。

ArrayList **默认容量DEFAULT_CAPACITY 是 10**。
并不是在初始化的时候就创建了 DEFAULT_CAPACITY = 10 的数组，而是在往里边 add 第一个数据的时候会扩容到 10。

- set(int index, E element)
该方法首先调用`rangeCheck(index)`来校验 index 变量是否超出数组范围，超出则抛出异常；
然后将新的 element 放入 Index 位置，返回 oldValue。

- add(E e)
将指定的元素添加到列表的尾部。
首先调用`ensureCapacityInternal(size+1)`
1、确定 minCapacity （现有元素的数量+1）。如果 elementData 是空，则取`Math.max(DEFAULT_CAPACITY, minCapacity)`
2、modCount++;
3、如果 minCapacity - elementData.length > 0，就要进行扩容操作`grow(minCapacity)`，扩容到`newCapacity = oldCapacity + (oldCapacity >> 1)`，**原容量的 1.5 倍**，最后通过`Arrays.copyOf(elementData, newCapacity)`扩容
4、最后把新元素e放在新索引的位置,也就是数组的尾部`elementData[size++] = e`。

- add(int index, E element)
在 index 位置插入 element。
1、首先调用`rangeCheckForAdd(index)`来校验 index 变量是否超出数组范围还有index要不小于0，超出则抛出异常；
2、调用`ensureCapacityInternal(size+1)`修改数组的容量+1；
3、然后后移元素System.arraycopy(elementData, index, elementData, index + 1,                       size - index);
最后把新元素e放在指定的位置`elementData[index] = element`。
所以，**尽可能避免使用 add(index,e) api，会导致复制数组，降低效率。**

- addAll(Collection<? extends E> c) 、 addAll(int index, Collection<? extends E> c)
将特定 Collection 中的元素添加到 Arraylist 末尾，第二个是指定位置。
当容量不足时，会扩容。

# ArrayList 什么情况下会扩容，怎么扩容的
随着向 ArrayList 中不断添加元素，其容量也会自动增长。
自动增长会带来数据向新数组的重新拷贝，因此，如果可预知数据量的多少，可**在构造 ArrayList 时指定其容量**。[这个人有演示](https://www.cnblogs.com/crossoverJie/p/11130043.html)

开发者可以调用` ensureCapacity(int minCapacity)` 操作来增加 ArrayList 实例的容量。
在存储元素等操作过程中，如add(E e)，遇到容量不足程序会内部调用private void方法 `ensureCapacityInternal(int minCapacity)`实现扩容。

数组进行扩容时，**会将老数组中的元素重新拷贝一份到新的数组中**，这种操作的代价是很高的，因此在实际使用时，我们应该尽量避免数组容量的扩张。
当我们可预知要保存的元素的多少时，要在构造 ArrayList 实例时，就指定其容量，以避免数组扩容的发生。

>扩容因子k为何是1.5？?
保证都是奇数？
1.5 可以充分利用移位操作，减少浮点数或者运算时间和运算次数？



# 删除元素流程
- 根据索引删除对象remove(int index)
本质上是把要删除的元素替换为它后面的元素,然后把最后一个元素赋值为null,手动GC,返回老的元素。

- 直接删除对象remove(Object o)
循环遍历数组，当元素第一次出现的时候，删除这个元素（只会删除index较小的那个节点），同时返回true，如果元素不存在，那么数组不改变，同时返回false。

从数组中移除元素的操作，也会导致被移除的元素以后的所有元素的向左移动一个位置。


# LinkedList
1. 是怎么实现的（实现了哪些接口）
2. 与linkedList的区别
3. 什么情况下会扩容，怎么扩容的

LinkedList是List接口的双向链表实现，不仅实现了List的方法，同时允许元素为null
获取index索引的元素时，会从链表的头部或尾部进行查找，哪边近从哪边开始。
注意该实现是线程非安全

## 查询
ArrayList 可以支持下标随机访问，效率非常高。  
LinkedList 由于底层不是数组，不支持通过下标访问，而是需要根据查询 index 所在的位置来判断是从头还是从尾进行遍历。

LinkedList 没有实现 RandomAccess 接口，这是因为 LinkedList 存储数据的内存地址**是不连续**的，所以不支持随机访问。

## 新增元素
LinkedList 新增元素也有两种情况，一种是直接将元素添加到队尾，一种是将元素插入到指定位置。  
新增元素就是创建了一个新的节点，只要把last节点指向最后一个元素即可，效率很高。

### ArrayList 和 LinkedList 新增元素时究竟谁快？
当两者的起始长度是一样的情况下：    
如果是从集合的头部新增元素，ArrayList 费时，因为需要对头部以后的元素进行复制。  
如果是从集合的中间位置新增元素，不好说，因为 LinkedList 需要遍历。    
如果是从集合的尾部新增元素，ArrayList 花费的时间应该比 LinkedList 少，因为数组是一段连续的内存空间，也不需要复制数组；而链表需要创建新的对象，前后引用也要重新排列。

## 删除元素
就是移除指定的节点，同时调整前后的节点即可，但是对于随机访问元素，它需要判断当前index离头部和尾部哪个更近，然后去依次查找，效率低下。

**所以对于随机快速读取数据，可以使用ArrayList；对于快速新增和删除元素，可以使用LinkList。**

>坊间一直流传：LinkedList 的写入效率高于 ArrayList，所以在写大于读的时候非常适用于 LinkedList 。
但是一旦写入的数据量大起来，由于LinkedList 虽然不需要复制内存，但却需要创建对象，变换指针等操作，不一定比提前预设了 数组长度的ArrayList效率高。

### ArrayList 和 LinkedList 删除元素时究竟谁快？
LinkedList 在删除比较靠前和比较靠后的元素时，非常高效，但如果删除的是中间位置的元素，效率就比较低了。
从集合头部删除元素时，ArrayList 费时；  
从集合中间位置删除元素时，LinkedList 费时；  
从集合尾部删除元素时，ArrayList 花费的时间比 LinkedList 少一点。

# ArrayList 与linkedList的区别



## ArrayList 和 LinkedList 遍历元素时究竟谁快？
对于ArrayList，用get(i)遍历比用foreach快！  
对于LinkedList，用foreach(迭代器)比get(i)快(在遍历 LinkedList 时，我们要尽量避免使用 for 循环遍历)！  

LinkedList 基于链表实现的，在使用 for 循环的时候，每一次 for 循环都会去遍历半个 List，所以严重影响了遍历的效率；  
ArrayList 则是基于数组实现的，可以实现快速随机访问，所以 for 循环效率非常高。 
LinkedList 的迭代循环遍历和 ArrayList 的迭代循环遍历性能相当，也不会太差，所以在遍历 LinkedList 时，我们要尽量避免使用 for 循环遍历。





# 多线程问题
- 不是同步的。
如果多个线程同时访问一个 ArrayList 实例，而其中一个线程从结构上修改了列表，那么它必须保持外部同步。
ps：结构上的修改是指任何添加或删除一个或多个元素的操作，或者显式调整底层数组的大小；仅仅设置元素的值不是结构上的修改。
因为，ArrayList 也采用了快速失败的机制，通过记录 modCount 参数来实现。
在面对并发的修改时，迭代器很快就会完全失败，而不是冒着在将来某个不确定时间发生任意不确定行为的风险。

## 一个ArrayList在循环过程中删除，会不会出问题

for (String a : list) remove 会快速异常；
for (int i = 0; i < list.size(); i++) 连续存储问题
因为删除了元素,Arraylist的长度变小了,索引也会改变,但是迭代的下标没有跟着变小。
最好是用迭代器 remove


## ArrayList 的线程安全集合是什么？
可以使用 CopyOnWriteArrayList 代替 ArrayList，它实现了读写分离。写操作复制一个新的集合，在新集合内添加或删除元素，修改完成后再将原集合的引用指向新集合。这样做的好处是可以高并发地进行读写操作而不需要加锁，因为当前集合不会添加任何元素。使用时注意尽量设置容量初始值，并且可以使用批量添加或删除，避免多次扩容，比如只增加一个元素却复制整个集合。

适合读多写少，单个添加时效率极低。CopyOnWriteArrayList 是 fail-safe 的，并发包的集合都是这种机制，fail-safe 在安全的副本上遍历，集合修改与副本遍历没有任何关系，缺点是无法读取最新数据。这也是 CAP 理论中 C 和 A 的矛盾，即一致性与可用性的矛盾。

CopyOnWriteArrayList 是 ArrayList 的线程安全版本，也是大名鼎鼎的 copy-on-write（COW，写时复制）的一种实现。

在读操作时不加锁，跟ArrayList类似；在写操作时，复制出一个新的数组，在新数组上进行操作，操作完了，将底层数组指针指向新数组。适合使用在读多写少的场景。

例如 add(E e) 方法的操作流程如下：使用 ReentrantLock 加锁，拿到原数组的length，使用 Arrays.copyOf 方法从原数组复制一个新的数组（length+1），将要添加的元素放到新数组的下标length位置，最后将底层数组指针指向新数组。
