Condition是Java提供了来实现等待/通知的类，Condition类还提供比wait/notify更丰富的功能，Condition对象是由lock对象所创建的。但是同一个锁可以创建多个Condition的对象，即创建多个对象监视器。这样的好处就是可以指定唤醒线程。notify唤醒的线程是随机唤醒一个。

```
    private Lock lock = new ReentrantLock();
    public Condition condition = lock.newCondition();

    condition.await();
    condition.signal();
```


最长等待时间，awaitUntil（Date deadline）在到达指定时间之后，线程会自动唤醒。但是无论是await或者awaitUntil，当线程中断时，进行阻塞的线程会产生中断异常。Java提供了一个awaitUninterruptibly的方法，使即使线程中断时，进行阻塞的线程也不会产生中断异常。