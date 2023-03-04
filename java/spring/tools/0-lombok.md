# Lombok使用
## @Data使用注意
@Data注解包含了@Getter @Setter @RequiredArgsConstructor @ToString @EqualsAndHashCode5个注解

### equals()和hashCode()
@EqualsAndHashCode 注解中实现了hashCode和equals方法，通过对象属性的计算hashCode和equals方法，因此具有相同属性的两个对象会被判断为相等。
但是在继承关系中，父类的hashCode只针对父类的所有属性进行运算，而子类的hashCode也只是针对子类才有的属性进行运算。
当使用@Data注解的类有属性定义到父类中，默认equals() 和 hashCode()方法不会使用父类的属性，这就导致了可能达不到我们期望的效果。不相等的两个对象会被误判为相等。

解决：
1）使用@Getter @Setter @ToString代替@Data并且自定义equals() 和 hashCode()方法，自己重写hashCode，带上内存地址System.identityHashCode(obj)；
2）子类使用@Data时同时加上 @EqualsAndHashCode(callSuper = true) 注解，子类会调用了父类的equals()和hashCode()。


### toString()
Method threw 'java.lang.StackOverflowError' exception. Cannot evaluate xxx.toString()
用了双向的引用，举个例子就是：对象A引用了对象B，对象B又反过来引用了对象A，导致出现了一个环形的引用链，使用toString()方法时，会不断的互相循环调用引用对象的方法，导致栈溢出。
