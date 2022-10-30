https://www.cnblogs.com/dolphin0520/p/3932921.html
# 什么是线程池
线程池的基本思想是一种对象池，在程序启动时就开辟一块内存空间，里面存放了众多(未死亡)的线程，池中线程执行调度由池管理器来处理。  

当有线程任务时，从池中取一个，执行完成后线程对象归池，这样可以避免反复创建线程对象所带来的性能开销，节省了系统的资源。  

因为线程其实也是一个对象，创建一个对象，需要经过类加载过程，销毁一个对象，需要走GC垃圾回收流程，都是需要资源开销的。


# 有4部分组成
1、线程池管理器（ThreadPool）：用于创建并管理线程池，包括 创建线程池，销毁线程池，添加新任务；  
2、工作线程（PoolWorker）：线程池中线程，在没有任务时处于等待状态，可以循环的执行任务；  
3、任务接口（Task）：每个任务必须实现的接口，以供工作线程调度任务的执行，它主要规定了任务的入口，任务执行完后的收尾工作，任务的执行状态等；  
4、任务队列（taskQueue）：用于存放没有处理的任务。提供一种缓冲机制。

# 作用和好处
当一个新任务需要运行时，如果线程池中有等待的工作线程，就可以开始运行了；否则进入等待队列，提高系统的响应速度。  
用线程池控制线程数量。每个工作线程都可以被重复利用，降低系统的消耗。  
延时执行、定时循环执行的策略等，运用线程池都能进行很好的实现，提供了线程的可管理功能。  
减少处理器单元的闲置时间，增加处理器单元的吞吐能力。

# 使用场景 
高并发场景：比如tomcat的处理机制，内置了线程池处理http请求；  
异步任务处理：比如spring的异步方法改造，增加@Asyn注解对应了一个线程池。

# 线程池里线程的执行流程
饭店（线程池），人多（超过核心线程数），先排队（阻塞队列），一直多，就招厨子（创建最大线程数），（超过最大极限，拒绝策略）今日客满

![](https://img-blog.csdnimg.cn/20200608092639652.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3YxMjM0MTE3Mzk=,size_16,color_FFFFFF,t_70)

# java 线程池 api
- 线程池顶层接口`Executor`，它只声明了一个方法execute(Runnable)，返回值为void，参数为Runnable类型，从字面意思可以理解，就是用来执行传进去的任务的。严格意义上讲Executor并不是一个线程池，而只是一个执行线程的工具；
- 真正的线程池接口`ExecutorService`继承了Executor接口，并声明了一些方法：submit、invokeAll、invokeAny以及shutDown等；
- 抽象类`AbstractExecutorService`实现了ExecutorService接口，基本实现了ExecutorService中声明的所有方法；
- `ThreadPoolExecutor`继承了类AbstractExecutorService。

## 怎么创建线程池
虽然在JDK中 Executors类里提供了一些静态工厂，生成一些常用的线程池，但通常情况下不建议开发人员直接使用（见《阿里巴巴java开发规范》）Executors去创建，而是通过ThreadPoolExecutor的方式，这样的处理方式让写的同学更加明确线程池的运行规则，规避资源耗尽的风险。
[阿里巴巴java开发规范中推荐了3种线程池创建方式](https://blog.csdn.net/wo541075754/article/details/103570466)
[例子](https://www.jianshu.com/p/6c6f396fc88e)

## 7个参数
```
public ThreadPoolExecutor(int corePoolSize,  //核心线程数最大值(正式员工)，prestartCoreThread()方法可提前预热线程池（提前创建好corePoolSize个工作线程）
		int maximumPoolSize,                //最大线程数(正式员工+外包员工)
		long keepAliveTime,                //非核心线程空闲的存活时间大小（外包员工这么久没需求会离开）
		TimeUnit unit,                    //存活时间单位，有7种静态属性：天、时、分、秒、毫秒、微秒、纳秒
   		BlockingQueue<Runnable> workQueue,     //存放待执行任务的阻塞队列
   		ThreadFactory threadFactory,         //用于设置（名字、daemon和优先级等等）创建线程的工厂，所有线程都是通过该工厂创建的，有默认实现。
   RejectedExecutionHandler handler        //线程池的拒绝策略/饱和策略
```
https://www.cnblogs.com/dolphin0520/p/3932921.html
[阻塞队列](https://www.cnblogs.com/dolphin0520/p/3932906.html)


# Executors 创建线程池类型
- new FixedThreadPool 定长线程池：固定线程数的线程池。corePoolSize = maximumPoolSize，keepAliveTime为0，工作队列使用无界的LinkedBlockingQueue。适用于为了满足资源管理的需求，而需要限制当前线程数量的场景，适用于负载比较重的服务器。

- new SingleThreadExecutor 单例线程池  ：只有一个线程的线程池。corePoolSize = maximumPoolSize = 1，keepAliveTime为0， 工作队列使用无界的LinkedBlockingQueue。适用于需要保证顺序的执行各个任务的场景。

- new CachedThreadPool 缓存线程池  ： 按需要创建新线程的线程池。核心线程数为0，最大线程数为 Integer.MAX_VALUE，keepAliveTime为60秒，工作队列使用同步移交 SynchronousQueue。该线程池可以无限扩展，当需求增加时，可以添加新的线程，而当需求降低时会自动回收空闲线程。适用于执行很多的短期异步任务，或者是负载较轻的服务器。

- new ScheduledThreadPool：创建一个以延迟或定时的方式来执行任务的线程池，工作队列为 DelayedWorkQueue。适用于需要多个后台线程执行周期任务。

- new WorkStealingPool：JDK 1.8 新增，用于创建一个可以窃取的线程池，底层使用 ForkJoinPool 实现。
————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/106609583

## newFixedThreadPool固定数目线程的线程池
```
  public static ExecutorService newFixedThreadPool(int nThreads, ThreadFactory threadFactory) {
        return new ThreadPoolExecutor(nThreads, nThreads,
                                      0L, TimeUnit.MILLISECONDS,
                                      new LinkedBlockingQueue<Runnable>(),
                                      threadFactory);
    }
```

```
   ExecutorService executor = Executors.newFixedThreadPool(10);
                    for (int i = 0; i < Integer.MAX_VALUE; i++) {
                        executor.execute(()->{
                            try {
                                Thread.sleep(10000);
                            } catch (InterruptedException e) {
                                //do nothing
                            }
            });
```
根据提交的任务逐个增加线程，直到最大值保持不变。

可控制线程最大并发数，超出的线程会在队列中等待。如果因异常结束，会新创建一个线程补充。


### 特点
核心线程数和最大线程数大小一样  
没有所谓的非空闲时间，即keepAliveTime为0  
**阻塞队列为无界队列LinkedBlockingQueue**

>Q：使用无界队列的线程池会导致内存飙升吗？  
答案 ：会的，newFixedThreadPool使用了无界的阻塞队列LinkedBlockingQueue，如果线程获取一个任务后，任务的执行时间比较长(比如，上面demo设置了10秒)，会导致队列的任务越积越多，导致机器内存使用不停飙升， 最终导致OOM。


### 使用场景 
用于**已知并发压力**的情况下，对线程数做限制。  
处理**CPU密集型**的任务，确保CPU在长期被工作线程使用的情况下，尽可能的少的分配线程，即适用执行长期的任务。

## newCachedThreadPool可缓存线程的线程池
```
   public static ExecutorService newCachedThreadPool(ThreadFactory threadFactory) {
        return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
                                      60L, TimeUnit.SECONDS,
                                      new SynchronousQueue<Runnable>(),
                                      threadFactory);
    }
```
```
  ExecutorService executor = Executors.newCachedThreadPool();
        for (int i = 0; i < 5; i++) {
            executor.execute(() -> {
                System.out.println(Thread.currentThread().getName()+"正在执行");
            });
        }
```
会根据任务自动新增或回收线程。

此线程池**不会对线程池大小做限制**，线程池大小完全依赖于操作系统（或者说JVM）能够创建的最大线程大小。推荐使用！

当提交任务的速度大于处理任务的速度时，**每次提交一个任务，就必然会创建一个线程**。  
极端情况下会创建过多的线程，耗尽 CPU 和内存资源。由于空闲 60 秒的线程会被终止，长时间保持空闲的 CachedThreadPool 不会占用任何资源。

### 特点
**核心线程数为0**    
**最大线程数为Integer.MAX_VALUE**  
阻塞队列是SynchronousQueue  
非核心线程空闲存活时间为60秒

### 使用场景
用于并发执行大量执行时间比较短的**小任务**。

## newSingleThreadExecutor单线程的线程池
```
  public static ExecutorService newSingleThreadExecutor(ThreadFactory threadFactory) {
        return new FinalizableDelegatedExecutorService
            (new ThreadPoolExecutor(1, 1,
                                    0L, TimeUnit.MILLISECONDS,
                                    new LinkedBlockingQueue<Runnable>(),
                                    threadFactory));
    }
```

```
  ExecutorService executor = Executors.newSingleThreadExecutor();
                for (int i = 0; i < 5; i++) {
                    executor.execute(() -> {
                        System.out.println(Thread.currentThread().getName()+"正在执行");
                    });
        }

```
当前的唯一线程，从队列取任务，执行完一个，再继续取，一个人（一条线程）夜以继日地干活。

保证按照提交顺序执行。如果因异常结束，会再创建一个新的。

### 特点
核心线程数为1  
最大线程数也为1  
阻塞队列是LinkedBlockingQueue  
keepAliveTime为0


### 使用场景
适用于串行执行任务的场景，一个任务一个任务地执行。


## newScheduledThreadPool定时及周期执行的线程池
```
    public ScheduledThreadPoolExecutor(int corePoolSize) {
        super(corePoolSize, Integer.MAX_VALUE, 0, NANOSECONDS,
              new DelayedWorkQueue());
    }
```

```
    /**
    创建一个给定初始延迟的间隔性的任务，之后的下次执行时间是上一次任务从执行到结束所需要的时间+* 给定的间隔时间
    */
    ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);

        scheduledExecutorService.scheduleWithFixedDelay(()->{
            System.out.println("current Time" + System.currentTimeMillis());
            System.out.println(Thread.currentThread().getName()+"正在执行");
        }, 1, 3, TimeUnit.SECONDS);
```

```
    /**
    创建一个给定初始延迟的间隔性的任务，之后的每次任务执行时间为 初始延迟 + N * delay(间隔) 
    */
    ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);

            scheduledExecutorService.scheduleAtFixedRate(()->{
            System.out.println("current Time" + System.currentTimeMillis());
            System.out.println(Thread.currentThread().getName()+"正在执行");
        }, 1, 3, TimeUnit.SECONDS);;
```

可以延时启动，定时启动的线程池。如来执行S秒后，每隔N秒执行一次的任务。

### 特点
最大线程数为Integer.MAX_VALUE  
阻塞队列是DelayedWorkQueue  
keepAliveTime为0  
scheduleAtFixedRate() ：按某种速率周期执行  
scheduleWithFixedDelay()：在某个延迟后执行

### 使用场景
需要多个后台线程执行周期任务的场景。

## newWorkStealingPool
JDK8新增，一个拥有多个任务队列的线程池，可以减少连接数，创建当前可用cpu数量的线程来并行执行。

根据所需的并行层次来动态创建和关闭线程，通过使用多个队列减少竞争，底层使用ForkJoinPool来实现。优势在于可以充分利用多CPU，把一个任务拆分成多个“小任务”，放到多个处理器核心上并行执行；当多个“小任务”执行完成之后，再将这些执行结果合并起来即可。


## Executors创建线程池的弊端
newFixedThreadPool和newSingleThreadExecutor：主要问题是堆积的请求处理队列可能会耗费非常大的内存，甚至OOM。    
newCachedThreadPool和newScheduledThreadPool：要问题是线程数最大数是Integer.MAX_VALUE，可能会创建数量非常多的线程，甚至OOM。

# 线程池的实现原理和线程的调度过程
https://blog.csdn.net/riemann_/article/details/115824556

# 线程池中的各个状态
线程池目前有5个状态：  
RUNNING：接受新任务并处理排队的任务。  
SHUTDOWN：不接受新任务，但处理排队的任务。  
STOP：不接受新任务，不处理排队的任务，并中断正在进行的任务。  
TIDYING：所有任务都已终止，workerCount 为零，线程转换到 TIDYING 状态将运行 terminated() 钩子方法。  
TERMINATED：terminated() 已完成。  
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL3N6X21tYml6X3BuZy9LUlJ4dnFHY2ljWkh6RlM2UE9nNlRnaWNpY3Y1SU10TGliV2pHODFzOHF1TFByWWRSYVJWOER2SjVDVTgxRFVsZHVzc1hXNG1Lb1NaRXA4NkNpYUhZY2FrWkNnLw?x-oss-process=image/format,png)

https://juejin.im/post/5d1882b1f265da1ba84aa676
![](https://user-gold-cdn.xitu.io/2019/7/15/16bf3b10e39a52d0?imageslim)

## 监控线程池
场景：当线程池出现问题，可以根据监控数据快速定位和解决问题。
线程池提供的主要监控参数：
![](https://www.hellojava.com/api/read.php?url=https://img2020.cnblogs.com/other/268922/202004/268922-20200411235000694-1712618717.jpg)
也可以自定义监控,通过自定义线程池，实现beforeExecute,afterExecute,terminated方法，可以在任务执行前，任务执行后，线程池关闭前记录监控数据。

# 终止线程池
终止线程池主要有两种方式：
shutdown：“温柔”的关闭线程池。不接受新任务，但是在关闭前会将之前提交的任务处理完毕。
shutdownNow：“粗暴”的关闭线程池，也就是直接关闭线程池，通过 Thread#interrupt() 方法终止所有线程，不会等待之前提交的任务执行完毕。但是会返回队列中未处理的任务。

# void execute(Runable)方法的执行流程
流程：
当产品提个需求，正式员工（核心线程）先接需求（执行任务）  
如果正式员工都有需求在做，即核心线程数（corePoolSize）已满，产品就把需求先放需求池（阻塞队列）排队等待执行（一个新提交的任务）。  
如果需求池(阻塞队列)也满了，但是这时候产品继续提需求,怎么办呢？那就请外包（非核心线程）来做。  
如果所有员工（最大线程数maximumPoolSize也满了）都有需求在做了，那就执行拒绝策略。  
如果外包员工把需求做完了，它经过一段（keepAliveTime）空闲时间，就离开公司了。  

[ThreadPoolExecutor中execute方法的源代码实现](https://blog.csdn.net/wo541075754/article/details/103570466)  
[源码分析2](http://www.justdojava.com/2019/04/29/java-thread-pool/)
```
    public void execute(Runnable command) {
        if (command == null)
            throw new NullPointerException();
       
        int c = ctl.get();
        if (workerCountOf(c) < corePoolSize) {
            if (addWorker(command, true))
                return;
            c = ctl.get();
        }
        if (isRunning(c) && workQueue.offer(command)) {
            int recheck = ctl.get();
            if (! isRunning(recheck) && remove(command))
                reject(command);
            else if (workerCountOf(recheck) == 0)
                addWorker(null, false);
        }
        else if (!addWorker(command, false))
            reject(command);
    }
```

创建工作线程
```
  private boolean addWorker(Runnable firstTask, boolean core) {
        retry:
        for (int c = ctl.get();;) {
            // Check if queue empty only if necessary.
            if (runStateAtLeast(c, SHUTDOWN)
                && (runStateAtLeast(c, STOP)
                    || firstTask != null
                    || workQueue.isEmpty()))
                return false;

            for (;;) {
                if (workerCountOf(c)
                    >= ((core ? corePoolSize : maximumPoolSize) & COUNT_MASK))
                    return false;
                if (compareAndIncrementWorkerCount(c))
                    break retry;
                c = ctl.get();  // Re-read ctl
                if (runStateAtLeast(c, SHUTDOWN))
                    continue retry;
                // else CAS failed due to workerCount change; retry inner loop
            }
        }

        boolean workerStarted = false;
        boolean workerAdded = false;
        Worker w = null;
        try {
            w = new Worker(firstTask);
            final Thread t = w.thread;
            if (t != null) {
                final ReentrantLock mainLock = this.mainLock;
                mainLock.lock();
                try {
                    // Recheck while holding lock.
                    // Back out on ThreadFactory failure or if
                    // shut down before lock acquired.
                    int c = ctl.get();

                    if (isRunning(c) ||
                        (runStateLessThan(c, STOP) && firstTask == null)) {
                        if (t.isAlive()) // precheck that t is startable
                            throw new IllegalThreadStateException();
                        workers.add(w);
                        int s = workers.size();
                        if (s > largestPoolSize)
                            largestPoolSize = s;
                        workerAdded = true;
                    }
                } finally {
                    //释放锁
                    mainLock.unlock();
                }
                if (workerAdded) {
                    //执行提交的任务，然后设置工作线程为启动状态
                    t.start();
                    workerStarted = true;
                }
            }
        } finally {
            if (! workerStarted)
                addWorkerFailed(w);
        }
        return workerStarted;
    }

```


### Future submit(Callable)方法
它实际上还是调用的execute()方法，只不过它利用了Future来获取任务执行结果。还可以通过Future对象的get方法接收抛出的异常，再进行处理。
execute适用于不需要关注返回值的场景，submit方法适用于需要关注返回值的场景。




# 四种拒绝策略
- AbortPolicy：中止策略，直接抛出异常，丢弃任务。阻止系统正常工作。(默认的)
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
           throw new RejectedExecutionException();
       }
```

- DiscardPolicy：抛弃策略。该策略默默的丢弃无法处理的任务，不予任何处理。这种策略和AbortPolicy几乎一样，也是丢弃任务，只不过他不抛出异常。
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {

       }
```

- DiscardOldestPolicy：抛弃最老策略。该策略将丢弃最老（位于工作队列头部）的一个请求，也就是即将被执行的任务，并尝试再次提交当前任务。如果再次失败，则重复此过程。
如果阻塞队列是一个优先队列，那么“抛弃最旧的”策略将导致抛弃优先级最高的任务，因此最好不要将该策略和优先级队列放在一起使用。
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
           if (!e.isShutdown()) {
               e.getQueue().poll();
               e.execute(r);
           }
       }
```


- CallerRunsPolicy：调用者运行策略。只要线程池未关闭，直接在调用者线程中，运行当前的被丢弃的任务。此策略提供简单的反馈控制机制，能够减缓新任务的提交速度。这个策略显然不想放弃执行任务。但是由于池中已经没有任何资源了，那么就直接使用调用该execute的线程本身（调用线程池执行任务的主线程）来执行。 ，由于执行任务需要一定时间，因此主线程至少在一段时间内不能提交任务，从而使得线程池有时间来处理完正在执行的任务。
                                                                                                                                                               

```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
           if (!e.isShutdown()) {
               r.run();
           }
       }
```

除了默认的4种策略之外，还可以根据业务需求（如记录日志或持久化不能处理的任务）自定义拒绝策略。通过实现`RejectedExecutionHandler`接口，在创建ThreadPoolExecutor对象时作为参数传入即可。
在spring-integration-core中便自定义了CallerBlocksPolicy。


# 什么情况触发拒绝策略：
1）线程池运行状态不是 RUNNING；
2）线程池已经达到最大线程数，并且阻塞队列已满时。

# 线程池有哪些队列？
线程池的排队策略与BlockingQueue有关。  
java.util.concurrent 中加入了 BlockingQueue 接口和一些阻塞队列类。

它实质上就是一种带有一点阻塞性质的 FIFO 数据结构。  

若BlockQueue是空的，这时如果有线程要从这个BlockingQueue取元素的时候将会被阻塞进入等待状态，直到别的线程在BlockingQueue中添加进了元素，被阻塞的线程才会被唤醒。同样，如果BlockingQueue是满的，试图往队列中存放元素的线程也会被阻塞进入等待状态，直到BlockingQueue里的元素被别的线程拿走才会被唤醒继续操作。

## ArrayBlockingQueue
**有界队列**，是一个用数组实现的有界阻塞队列。最大的特点便是可以防止资源耗尽的情况发生。

[源码分析](https://www.jianshu.com/p/3fedd6e53cf9)

>队列大小和最大池大小可能需要相互折衷：使用大型队列和小型池可以最大限度地降低 CPU 使用率、操作系统资源和上下文切换开销，但是可能导致人工降低吞吐量。如果任务频繁阻塞（例如，如果它们是 I/O边界），则系统可能为超过您许可的更多线程安排时间。使用小型队列通常要求较大的池大小，CPU使用率较高，但是可能遇到不可接受的调度开销，这样也会降低吞吐量。

## LinkedBlockingQueue
基于链表结构的阻塞队列，容量可以选择进行设置，**不设置的话，将是一个无边界的阻塞队列**，最大长度为Integer.MAX_VALUE，吞吐量通常要高于ArrayBlockingQuene；

newFixedThreadPool线程池使用了这个队列。

>当每个任务完全独立于其他任务，即任务执行互不影响时，适合于使用无界队列；例如，在 Web页服务器中。这种排队可用于处理瞬态突发请求，当命令以超过队列所能处理的平均数连续到达时，此策略允许无界线程具有增长的可能性。

对于`无界队列`来说，总是可以加入的（资源耗尽，当然另当别论）。换句说，永远也不会触发产生新的线程！corePoolSize大小的线程数会一直运行，忙完当前的，就从队列中拿任务开始运行。所以要防止任务疯长，比如任务运行的实行比较长，而添加任务的速度远远超过处理任务的时间，而且还不断增加，不一会儿就爆了。

## SynchronousQueue
（同步队列）一个不存储元素的阻塞队列，无界，但每个插入操作必须有另一个线程正在等待接受这个元素，否则插入操作一直处于阻塞状态，吞吐量通常要高于LinkedBlockingQuene，另外，SynchronousQueue的**直接提交策略**可以避免在处理可能具有内部依赖性的请求集时出现锁（因为可保证有序）。

只有当线程池是无界的或者可以拒绝任务时，该队列才有实际价值。Executors.newCachedThreadPool使用了该队列。


并且线程池的当前大小小于最大值，那么线程池将创建一个线程，否则根据拒绝策略，这个任务将被拒绝。使用直接移交将更高效，因为任务会直接移交给执行它的线程，而不是被放在队列中，然后由工作线程从队列中提取任务。

会让新添加的任务立即得到执行，如果线程池中所有的线程都在执行，那么就会去创建一个新的线程去执行这个任务。?????


## DelayQueue
一个由优先级堆支持的、基于时间的无界调度队列。队列中的元素必须实现Delayed接口，在创建元素时可以指定多久才能从队列中获取当前元素。只有在延迟期满时才能从队列中提取元素。一般用于缓存系统的设计、定时任务调度等。
`根据指定的执行时间从小到大排序`，否则根据插入到队列的先后排序。`newScheduledThreadPool线程池使用了这个队列`。
## PriorityBlockingQueue
（优先级队列）是具有优先级的无界阻塞队列，默认情况下元素采取自然顺序排列，也可以通过比较器comparator来指定元素的排序规则。元素按照升序排列。

## LinkedTransferQueue
是一个由链表结构组成的无界阻塞TransferQueue队列。相对于其他阻塞队列LinkedTransferQueue多了tryTransfer和transfer方法。

LinkedBlockingDeque是一个由链表结构组成的双向阻塞队列。双端队列因为多了一个操作队列的入口，在多线程同时入队时，也就减少了一半的竞争。


## 使用队列有什么需要注意的吗？
使用有界队列时，需要注意线程池满了后，被拒绝的任务如何处理。

使用无界队列时，需要注意如果任务的提交速度大于线程池的处理速度，可能会导致内存溢出。

## 阻塞队列是如何实现的，即如何进行阻塞？
显示锁Lock+条件队列Condition。
这里维护两个条件队列，对应提供了可阻塞的take和put操作。
如果队列已经满了，那么put方法将阻塞直到有空间可用；如果队列为空，那么take方法将会阻塞直到有元素可用。
拿ArrayBlockingQueue来说，其他实现类实现阻塞的方式应该类似。如果某一方take和put失败，则调用对应Condition的await方法，调用的线程将被阻塞，进入等待条件的队列，并释放锁。如果某一方成功（即成功调用dequeue或enqueue方法），则会调用对应的Condition的signal方法，等待条件队列中的某个线程将被选中并激活。
![](https://images2018.cnblogs.com/blog/1313132/201809/1313132-20180903201724109-827675650.png)

ps:核心线程在获取任务时，通过阻塞队列的 take() 方法实现的一直阻塞（存活）。  
非核心线程如何实现在 keepAliveTime 后死亡？  
原理同上，也是利用阻塞队列的方法，在获取任务时通过阻塞队列的 poll(time,unit) 方法实现的延迟死亡。

### 为何要使用Lock+Condition，而不是隐式的synchronized和wait/notify条件队列？
引入显式的条件队列Condition的作用是，分离等待条件的线程，将等待同一条件的线程分配到同一个队列，这时候，就可以只唤醒等待特定条件的线程了。  
![](https://images2018.cnblogs.com/blog/1313132/201809/1313132-20180903101907529-199385426.png)  

# 实际使用中，线程池的大小配置多少合适？
要想合理的配置线程池大小。  


- I/O密集型
在我们日常的开发中，我们的任务几乎是离不开I/O的，常见的网络I/O（RPC调用）、磁盘I/O（数据库操作），并且I/O的等待时间通常会占整个任务处理时间的很大一部分，在这种情况下，开启更多的线程可以让 CPU 得到更充分的使用，一个较合理的计算公式如下：
网上常见的说法是设置 线程数 = CPU数 * 2 ，尽量利用CPU资源。
`线程数 = CPU数 * CPU利用率 * (任务等待时间 / 任务计算时间 + 1)`
例如我们有个定时任务，部署在4核的服务器上，该任务有100ms在计算，900ms在I/O等待，则线程数约为：4 * 1 * (1 + 900 / 100) = 40个。


`int corePoolSize = Runtime.getRuntime().availableProcessors() * 2;`

- 计算密集型
设置 线程数 = CPU数 + 1，更多的线程数也只能增加上下文切换，不能增加CPU利用率。。



当然，具体我们还要结合实际的使用场景来考虑。如果要求比较精确，可以通过压测来获取一个合理的值。  
另外队列最好是有界的, 防止意外把内存撑爆。  

————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/106609583

![](https://www.hellojava.com/api/read.php?url=https://img2020.cnblogs.com/other/268922/202004/268922-20200411235000413-28627178.jpg)

[java线程池大小设置参考](https://www.zhihu.com/question/38128980)

>Q：单台机器4核，服务A请求时间为5S，但是A调用的某个服务B耗时4.98S，A服务超时时间是10S，问100QPS的访问量，动态线程池CoreSize,maxSize,等待队列怎么指定？


# 源码之在线程执行前后，复位Threadlocal中的值
ThreadPoolExecutor线程池中的其中三个方法：

protected void beforeExecute(Thread t, Runnable r) { }
protected void afterExecute(Runnable r, Throwable t) { }
protected void terminated() { }
https://blog.csdn.net/odeng888/article/details/50578111

getQueue() 、getPoolSize() 、getActiveCount()、getCompletedTaskCount()等获取与线程池相关属性的方法

# 线程池是怎么被设计成单例模式的
ThreadPool源码
```
 // 获取单例的线程池对象
    public static ThreadPool getThreadPool() {
        if (mThreadPool == null) {
            synchronized (ThreadManager.class) {
                if (mThreadPool == null) {
                    int cpuNum = Runtime.getRuntime().availableProcessors();// 获取处理器数量
                    int threadNum = cpuNum * 2 + 1;// 根据cpu数量,计算出合理的线程并发数
                    mThreadPool = new ThreadPool(threadNum, threadNum, 0L);
                }
            }
        }
        return mThreadPool;
    }
```

# 源码之ctl 
int 类型有32位，其中 ctl 的低29为用于表示 workerCount，高3位用于表示 runState

ctl 这么设计的主要好处是将对 runState 和 workerCount 的操作封装成了一个原子操作。

runState 和 workerCount 是线程池正常运转中的2个最重要属性，线程池在某一时刻该做什么操作，取决于这2个属性的值。

因此无论是查询还是修改，我们必须保证对这2个属性的操作是属于“同一时刻”的，也就是原子操作，否则就会出现错乱的情况。如果我们使用2个变量来分别存储，要保证原子性则需要额外进行加锁操作，这显然会带来额外的开销，而将这2个变量封装成1个 AtomicInteger 则不会带来额外的加锁开销，而且只需使用简单的位操作就能分别得到 runState 和 workerCount。

由于这个设计，workerCount 的上限 CAPACITY   = (1 << 29) - 1，对应的二进制原码为：0001 1111 1111 1111 1111 1111 1111 1111（不用数了，29个1）。

通过 ctl 得到 runState，只需通过位操作：ctl & ~CAPACITY。

~（按位取反），于是“~CAPACITY”的值为：1110 0000 0000 0000 0000 0000 0000 0000，只有高3位为1，与 ctl 进行 & 操作，结果为 ctl 高3位的值，也就是 runState。

通过 ctl 得到 workerCount 则更简单了，只需通过位操作：c & CAPACITY。
————————————————
版权声明：本文为CSDN博主「程序员囧辉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v123411739/article/details/106609583

# 怎么抛异常的
https://www.cnblogs.com/thisiswhy/p/13704940.html

- 通过try…catch捕获异常
- UncaughtExceptionHandler
如果很多线程任务默认的异常处理机制都是相同的，可以通过Thread类的UncaughtExceptionHandler来设置线程默认的异常处理机制。
实现UncaughtExceptionHandler接口，并调用Thread#setUncaughtExceptionHandler(UncaughtExceptionHandler)方法。如果想设置为全局默认异常处理机制，则可调用Thread#setDefaultUncaughtExceptionHandler(UncaughtExceptionHandler)方法。

```
public class ThreadPool {
	public static void main(String[] args) {
		ThreadFactory namedThreadFactory = new ThreadFactoryBuilder()
				.setNameFormat("demo-pool-%d")
				.setUncaughtExceptionHandler(new LogUncaughtExceptionHandler())
				.build();
		ExecutorService pool = new ThreadPoolExecutor(5, 200,
				0L, TimeUnit.MILLISECONDS,
				new LinkedBlockingQueue<Runnable>(1024), namedThreadFactory, new ThreadPoolExecutor.AbortPolicy());
		pool.execute(() -> {
			throw new RuntimeException("测试异常");
		});
		pool.shutdown();
	}
	static class  LogUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {
		@Override
		public void uncaughtException(Thread t, Throwable e) {
			System.out.println("打印LogUncaughtExceptionHandler中获得的异常信息:"   e.getMessage());
		}
	}
}
```

使用UncaughtExceptionHandler的方法只适用于execute方法执行的任务，而对submit方法是无效。submit执行的任务，可以通过返回的Future对象的get方法接收抛出的异常，再进行处理。这也算是execute方法与submit方法的差别之一。

- 重写ThreadPoolExecutor的afterExecute方法，处理传递的异常引用
![](https://user-gold-cdn.xitu.io/2019/7/14/16bec33ca5559c93?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)




# 手写一个定时的线程池
https://cloud.tencent.com/developer/article/1761380


