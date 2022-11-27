队列是遵循先进先出（First-In-First-Out）模式的，但有些时候需要在队列中基于优先级处理对象。

PriorityQueue是基于优先堆的一个无界队列，这个优先队列中的元素可以默认自然排序或者通过提供的Comparator（比较器）在队列实例化的时排序。

优先队列不允许空值，而且不支持non-comparable（不可比较）的对象，比如用户自定义的类。优先队列要求使用Java Comparable和Comparator接口给对象排序，并且在排序时会按照优先级处理其中的元素。

使用迭代器时，PriorityQueue 类不保证元素的任何顺序。

add()

offer()

poll()

# PriorityBlockingQueue
PriorityQueue是非线程安全的，所以Java提供了PriorityBlockingQueue（实现BlockingQueue接口）用于Java多线程环境。