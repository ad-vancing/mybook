# 异步处理的幂等性

Java有哪些锁？区别在哪？底层如何实现的？为什么非公平锁效率高？

# 死锁
不同的线程都在等不可能释放的锁时。 
避免双方互相持有对方锁的情况。  

## 如何解决死锁
通过jps，获取进程pid，然后执行`jstack -l pid号`查看进程是否存在死锁。 
https://zhuanlan.zhihu.com/p/136294283


# 线程的状态都有哪些
初始(NEW)：新创建了一个线程对象，但还没有调用start()方法，而且就算调用了改方法也不代表状态立即改变。  
就绪(RUNNABLE)  
运行（Running）：在运行的状态肯定就处于RUNNABLE状态。  
阻塞(BLOCKED)：表示线程阻塞，或者说线程已经被挂起了。  
     等待堵塞：执行的线程执行wait()方法，JVM会把该线程放入等待池中。
     同步堵塞：执行的线程在获取对象的同步锁时。若该同步锁被别的线程占用。则JVM会把该线程放入锁池中。 
     其它堵塞：执行的线程执行sleep()或join()方法。或者发出了I/O请求时。JVM会把该线程置为堵塞状态。当sleep()状态超时、join()等待线程终止或者超时、或者I/O处理完毕时。线程又一次转入就绪状态。（注意,sleep是不会释放持有的锁）  
终止(TERMINATED)：表示该线程已经执行完毕。
![](https://img2018.cnblogs.com/blog/1113901/201906/1113901-20190625232635949-798047380.png)
https://www.cnblogs.com/yuanqinnan/p/11087354.html

# ABC三个线程如何保证顺序执行



# 可重入锁的用处及实现原理，写时复制的过程，读写锁，分段锁（ConcurrentHashMap中的segment）
表示支持重新进入的锁，也就是说，如果当前线程 t1 通过调用 lock 方法获取了锁之后，再次调用 lock，是不会再阻塞去获取锁的，直接增加重试次数就行了。synchronized 和 ReentrantLock 都是可重入锁。
重入锁的设计目的是避免线程的死锁。

另外，子类也可以通过可重入锁调用父类的同步方法。  

原理：每个对象拥有一个计数器，当线程获取该对象锁后，计数器就会加一，释放锁后就会将计数器减一。

# 如何让子线程运行结束再执行主线程
https://www.cnblogs.com/paddix/p/5381958.html
①、t1.join()
t1.start();后面接上t1.join()代码
②、while(t1.isAlive())
判断子线程是否还存活
③、while(Thread.activeCount()>1) Thread.yield()
判断活跃的线程是否大于1
④、CountDownLatch 
一、二两种办法需要知道线程的名字，当有很多线程同时执行的时候，有时候，我们是无法直观的知道每个线程的名字，这两个办法用的很少见。
第四种办法在多线程的情况下也可以使用，就是需要设置CountDownLatch latch = new CountDownLatch(n)，指定需要等待的线程数。
第三种办法无需知道线程的名字和线程的数量，使用起来很直观。
5) Future future = executorService.submit(subThread);
阻塞方法future.get();
Future是一个任务执行的结果, 他是一个将来时, 即一个任务执行, 立即异步返回一个Future对象, 等到任务结束的时候, 会把值返回给这个future对象里面。
```

		Callable ca1 = new Callable(){
 
			@Override
			public String call() throws Exception {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				return "凉菜准备完毕";
			}
		};
		FutureTask<String> ft1 = new FutureTask<String>(ca1);
```

```
private static final Callable<String> callable1 = () -> {
        Thread.sleep(3000L); // 模拟烧水动作
        System.out.println("烧开水成功");
        return "hot_water";
    };
    private static final FutureTask<String> ft1 = new FutureTask<>(callable1);
    private static final Callable<String> callable2 = () -> {
        if(ft1.get().equals("hot_water")){
            Thread.sleep(1000L); // 模拟泡茶动作
            System.out.println("泡茶成功");
            return "tea is done";
        }else{
            return "tea is not done";
        }
    };
    private static final FutureTask<String> ft2 = new FutureTask<>(callable2);
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        new Thread(ft1).start();
        new Thread(ft2).start();
        System.out.println(ft2.get());
    }
}
```

# Java实现多线程有哪几种方式
Thread 和 Runnable
Callable配合Future
如何实现控制线程在某段时间内完成，不完成就撤销，答：实现Callable接口，返回FutureTask类或者Future接口
 