ThreadLocal 是 JDK java.lang 包中的一个用来实现`相同线程数据共享，不同的线程数据隔离`的一个工具类。
[清理过程](https://cloud.tencent.com/developer/article/1627478)

# 引子： 在多线程环境下，如何防止自己的变量被其它线程篡改？
（1）Synchronized是通过线程等待，牺牲时间来解决访问冲突
（2）ThreadLocal是通过每个线程单独一份存储空间，牺牲空间来解决冲突

# Threadlocal作用
数据的线程隔离。
提供线程内的局部变量，这种变量在线程的生命周期内起作用，减少同一个线程内多个函数或者组件之间一些公共变量的传递的复杂度。
从线程的角度看，目标变量就像是线程的本地变量，这也是类名中“Local”所要表达的意思。

ThreadLocal使得每一个访问该变量的线程**在其内部都有一个独立的初始化的变量副本**。
所以每一个线程都**可以独立地改变自己的副本，而不会影响其它线程所对应的副本**。



# Threadlocal怎么使用
ThreadLocal实例变量通常采用private static在类中被修饰。

在每条线程中可以通过如下方法操作ThreadLocal：  
set(obj)：向当前线程中存储数据  
get()：获取当前线程中的数据  
remove()：删除当前线程中的数据  
initialValue()：返回该线程局部变量的初始值。

线程运行之后初始化一个可以泛型的ThreadLocal对象，之后这个线程只要在remove之前去get，都能拿到之前set的值，其他线程使用get（）方法是不会拿到其他线程的值的。

[附加：避免引用传递的问题](https://developer.aliyun.com/article/747469)

# 源码实现
每个线程Thread都维护了自己的ThreadLocal变量，数据是存在自己线程中的。

![](https://img2022.cnblogs.com/blog/1331583/202209/1331583-20220917175856072-226789412.png)

## ThreadLocalMap 作用
Thread有个`ThreadLocal.ThreadLocalMap threadLocals `成员变量，这个ThreadLocalMap是ThreadLocal的静态内部类`static class ThreadLocalMap`，一个线程不管有多少个局部变量，都使用同一个ThradLocalMap来保存！

## ThreadLocalMap怎么保存线程的局部变量
ThreadLocalMap使用 Entry[] 数组（初始化时创建了默认长度是16的Entry数组，超过2/3会扩容）来存放该线程内部以当前的 ThreadLocal 的引用(它的**弱引用**)为key与局部变量值(value)的映射。

类似HashMap的结构，只是ThreadLocalMap中并没有链表结构。

```
static class ThreadLocalMap {
    /**
     * The entries in this hash map extend WeakReference, using
     * its main ref field as the key (which is always a
     * ThreadLocal object).  Note that null keys (i.e. entry.get()
     * == null) mean that the key is no longer referenced, so the
     * entry can be expunged from table.  Such entries are referred to
     * as "stale entries" in the code that follows.
     */
   //使用 WeakReference<ThreadLocal<?>> 把ThreadLocal对象变成一个弱引用的对象
    static class Entry extends WeakReference<ThreadLocal<?>> {
        /** The value associated with this ThreadLocal. */
        Object value;
        Entry(ThreadLocal<?> k, Object v) {
            super(k);
            value = v;
        }
    }
    /**
     * The table, resized as necessary.
     * table.length MUST always be a power of two.
     */
    private Entry[] table;
}
```

# ThreadLocal 存变量过程
**ThreadLocal 本身并不存储线程的变量值，它只是一个工具，用来维护线程内部的 Map，帮助存和取变量。**

当执行set方法时，ThreadLocal首先会获取当前线程对象，然后获取当前线程的ThreadLocalMap对象。再以当前ThreadLocal对象为key，将值存储进ThreadLocalMap对象中。
```
//set 方法
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
            // set 具体见下
            map.set(this, value); else
            createMap(t, value);
}
//获取线程中的ThreadLocalMap 字段！！
ThreadLocalMap getMap(Thread t) {
    return t.threadLocals;
}
//创建线程的变量
void createMap(Thread t, T firstValue) {
    t.threadLocals = new ThreadLocalMap(this, firstValue);
}
```
# ThreadLocalMap 如何解决 Hash 冲突？
```
private void set(ThreadLocal<?> key, Object value) {
    Entry[] tab = table;
    int len = tab.length;
    //获取 hash 值，用于数组中的下标
    int i = key.threadLocalHashCode & (len-1);
    //如果数组该位置有对象则进入
    for (Entry e = tab[i];
             e != null;
             e = tab[i = nextIndex(i, len)]) {
        ThreadLocal<?> k = e.get();
        //k 相等则覆盖旧值
        if (k == key) {
            e.value = value;
            return;
        }
        //此时说明此处 Entry 的 k 中的对象实例已经被回收了，需要替换掉这个位置的 key 和 value
        if (k == null) {
            replaceStaleEntry(key, value, i);
            return;
        }
    }
    //创建 Entry 对象，新建结点插入
    tab[i] = new Entry(key, value);
    int sz = ++size;
    if (!cleanSomeSlots(i, sz) && sz >= threshold)
            rehash();
}

```
采用**线性探测**的方式解决 Hash 冲突。  
如果发现这个位置上已经被其他的 key 值占用，则利用固定的算法`(nextIndex(i, len))`寻找一定步长的下个位置，依次判断，直至找到能够存放的位置。

```
        private static int nextIndex(int i, int len) {
            return ((i + 1 < len) ? i + 1 : 0);
        }
```
就是简单的步长加1，寻找下一个相邻的位置。

# ThreadLocal 取变量过程
ThreadLocal首先会获取当前线程对象，然后获取当前线程的ThreadLocalMap对象。再以当前ThreadLocal对象为key，获取对应的value。
```
public T get() {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null) {
        ThreadLocalMap.Entry e = map.getEntry(this);
        if (e != null) {
            @SuppressWarnings("unchecked")
                        T result = (T)e.value;
            return result;
        }
    }
    return setInitialValue();
}
private T setInitialValue() {
    T value = initialValue();
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
            map.set(this, value); else
            createMap(t, value);
    return value;
}
```


# ThreadLocalMap 为什么用数组？
用数组是因为要存储不同类型的TreadLocal范型对象。



# ThreadLocalMap 的 key 为什么是 ThreadLocal 对象的弱引用？
>弱引用的对象在GC时会被回收。

1、（对立面的坏处）强引用导致导致内存泄漏。ThreadLocalMap 持有 ThreadLocal 的强引用，如果没有手动删除，ThreadLocal 不会被回收，则会导致内存泄漏。

2、（正面的好处）使用弱引用，ThreadLocal对象使用完毕，没有强引用指向它的时候，垃圾收集器就会自动回收这个Key，从而达到节约内存的目的。对应的 value 在下一次 ThreadLocalMap 调用 set、get、remove 的时候被清除。


# ThreadLocal 的内存泄露问题
ThreadLocal在没有外部强引用时，发生GC时会被回收，如果创建ThreadLocal的线程一直持续运行（线程被复用），那么这个Entry对象中的value就有可能一直得不到回收，发生内存泄露。

## 解决方案：
每次操作set、get、remove操作时，ThreadLocal都会将key为null的Entry删除，从而避免内存泄漏。
**完成ThreadLocal的使用后要养成手动调用remove的习惯**。
ps：如果一个线程运行周期较长，而且将一个大对象放入ThreadLocalMap后便不再调用set、get、remove方法，此时该仍然可能会导致内存泄漏。

# Threadlocal 常见使用场景之源码
Hibernate 的 session 获取场景；  
spring中，如Bean、事务管理、任务调度、AOP、事务隔离级别（TransactionSynchronizationManager）等；
Spring采用Threadlocal的方式，来保证单个线程中的数据库操作使用的是同一个数据库连接，同时，采用这种方式可以使业务层使用事务时不需要感知并管理connection对象，通过传播级别，巧妙地管理多个事务配置之间的切换，挂起和恢复。
key是DataSource，value是Connection？？

cookie，session等数据隔离。

# Threadlocal 使用场景
当某些数据是以线程为作用域并且不同线程有不同数据副本时，考虑ThreadLocal。
无状态，副本变量独立后不影响业务逻辑的高并发场景。
如果如果业务逻辑强依赖于副本变量，则不适合用ThreadLocal解决。
实例需要在多个方法中共享，但不希望被多线程共享

它通过为每个线程提供一个独立的变量副本解决了变量并发访问的冲突问题。一般来说，ThreadLocal比直接使用synchronized同步机制解决线程安全问题更简单，更方便，且对并发性处理效果更好。例如：在并发环境下，服务器为每个用户开一个线程创建一个ThreadLocal变量来存放用户信息；对于数据库的并发操作，我们可以用一个ThreadLocal变量来存放Connection；在。

各个线程之间的变量互不干扰，在高并发场景下，可以实现无状态的调用，适用于各个线程不共享变量值的操作。
一句话说就是 ThreadLocal 适用于变量在线程间隔离（不同的线程数据隔离）而在方法或类间共享的场景。





# Threadlocal 项目中的使用
web项目中我们可以使用ThreadLocal保存用户Session信息；也可以使用在网关使用ThreadLocal来做一些简单的性能统计（比如说接口耗时）；

Web系统Session的存储就是ThreadLocal一个典型的应用场景。

Web容器采用线程隔离的多线程模型，也就是每一个请求都会对应一条线程，线程之间相互隔离，没有共享数据。这样能够简化编程模型，程序员可以用单线程的思维开发这种多线程应用。

当请求到来时，可以将当前Session信息存储在ThreadLocal中，在请求处理过程中可以随时使用Session信息，每个请求之间的Session信息互不影响。当请求处理完成后通过remove方法将当前Session信息清除即可。

不正当的使用会造成OOM内存溢出！！！

## 存储用户Session
```
private static final ThreadLocal threadSession = new ThreadLocal();

    public static Session getSession() throws InfrastructureException {
        Session s = (Session) threadSession.get();
        try {
            if (s == null) {
                s = getSessionFactory().openSession();
                threadSession.set(s);
            }
        } catch (HibernateException ex) {
            throw new InfrastructureException(ex);
        }
        return s;
    }
```
## 解决SimpleDateFormat线程安全的问题
当我们使用SimpleDataFormat的parse()方法时，内部有一个Calendar对象，调用SimpleDataFormat的parse()方法会先调用Calendar.clear（），然后调用Calendar.add()，如果一个线程先调用了add()然后另一个线程又调用了clear()，这时候parse()方法解析的时间就不对。

```
public class DateUtil {
    private static ThreadLocal<SimpleDateFormat> format1 = new ThreadLocal<SimpleDateFormat>() {
        @Override
        protected SimpleDateFormat initialValue() {
            return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        }
    };

    public static String formatDate(Date date) {
        return format1.get().format(date);
    }
}
```
这里的DateUtil.formatDate()就是线程安全的了。(Java8里的 java.time.format.DateTimeFormatter是线程安全的，Joda time里的DateTimeFormat也是线程安全的）。

![](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/7/26/1738b4545af84ec3~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

# 软引用&弱引用
软引用：对于软引用关联着的对象，在系统将要发生内存溢出异常之前，将会把这些对象列进回收范围进行第二次回收。如果这次回收还没有足够的内存，才会抛出内存溢出异常。  
弱引用：被弱引用关联的对象，在垃圾回收时，如果这个对象只被弱引用关联（没有任何强引用关联他），那么这个对象就会被回收。

# InheritableThreadLocal
使用InheritableThreadLocal可以实现多个线程访问ThreadLocal的值
```
private void test() {    
final ThreadLocal threadLocal = new InheritableThreadLocal();       
threadLocal.set("😄");    
Thread t = new Thread() {        
    @Override        
    public void run() {            
      super.run();            
      Log.i( "💸 =" + threadLocal.get());        
    }    
  };          
  t.start(); 
} 
```