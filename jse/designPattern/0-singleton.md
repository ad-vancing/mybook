单例模式是指在内存中只会创建且仅创建一次对象的设计模式。在程序中多次使用同一个对象且作用相同时，为了防止频繁地创建对象使得内存飙升，单例模式可以让程序仅在内存中创建一个对象，让所有需要调用的地方都共享这一单例对象。


两种类型：  
懒汉式：在真正需要使用对象时才去创建该单例类对象
饿汉式：在类加载时已经创建好该单例对象，等待被程序使用

# 懒汉式优化
1 要解决的是线程安全问题

2 每次去获取对象都需要先获取锁，并发性能非常地差，极端情况下，可能会出现卡顿现象。  
接下来要做的就是优化性能：目标是如果没有实例化对象则加锁创建，如果已经实例化了，则不需要加锁，直接获取实例。
Double Check（双重校验） + Lock（加锁）
```
public static Singleton getInstance() {
    if (singleton == null) {  // 线程A和线程B同时看到singleton = null，如果不为null，则直接返回singleton
        synchronized(Singleton.class) { // 线程A或线程B获得该锁进行初始化
            if (singleton == null) { // 其中一个线程进入该分支，另外一个线程则不会进入该分支
                singleton = new Singleton();
            }
        }
    }
    return singleton;
}

作者：程序员cxuan
链接：https://juejin.cn/post/6854573210495631374
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

3 使用 volatile 防止指令重排  
线程 B 判断 singleton 已经不为空，获取到未初始化的singleton 对象，就会报 NPE 异常。

# 反射和序列化都可以把单例对象破坏掉
在《Effective Java》书中，给出了终极解决方法————枚举实现
在程序启动时，会调用 Singleton 的空参构造器，实例化好一个Singleton 对象赋给 INSTANCE，之后再也不会实例化。

枚举类默认继承了 Enum 类，在利用反射调用 newInstance() 时，会判断该类是否是一个枚举类，如果是，则抛出异常。  

在读入 Singleton 对象时，每个枚举类型和枚举名字都是唯一的，所以在序列化时，仅仅只是对枚举的类型和变量名输出到文件中，在读入文件反序列化成对象时，使用 Enum 类的 valueOf(String name) 方法根据变量的名字查找对应的枚举对象。
所以，在序列化和反序列化的过程中，只是写出和读入了枚举类型和名字，没有任何关于对象的操作。

# 总结
懒汉式、饿汉式、双重校验锁、静态加载，内部类加载、枚举类加载

![](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2020/5/17/17221e53888f0ad6~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)
