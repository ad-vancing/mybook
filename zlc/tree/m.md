https://blog.csdn.net/Real_Fool_/article/details/113930623



# 二叉树
二叉树就是每个节点最多有两个子节点的树。

二叉树有两种主要的形式：满二叉树和完全二叉树。

## 满二叉树
如果一棵二叉树只有度为0的结点和度为2的结点，并且**度为0的结点在同一层上**，则这棵二叉树为满二叉树。

## 完全二叉树
除了最底层节点可能没填满外，其余每层节点数都达到最大值，并且最下面一层的节点都集中在该层最左边的若干位置。

# 二叉查找树/排序树/搜索树 binary search tree
之前的概念没有数值，二叉搜索树是有数值的了，二叉搜索树是一个有序树。

若左子树非空，则左子树上所有结点的值均小于根结点的值；

若右子树非空，则右子树上所有结点的值均大于根结点的值；

它的左、右子树也分别为二叉排序树。

在n个节点中找到目标值，一般只需要log(n)次比较。

# 平衡二叉树查找树/排序树/搜索树 AVL（Adelson-Velsky and Landis）
它是一棵空树或它的左右两个子树的高度差的绝对值不超过1，并且左右两个子树都是一棵平衡二叉树。

从根到每片叶子的路径长度最多相差1。

对二叉查找树而言，越平衡则查找效率越高。

# 遍历二叉树
前序：中、左、右

中序：左、中、右

后续：左、右、中

[一个有趣的演示](https://www.bilibili.com/video/BV1Ub4y147Zv/?spm_id_from=333.337.search-card.all.click)  
https://www.jianshu.com/p/456af5480cee

# 练习
[二叉树的层序遍历](https://leetcode.cn/problems/binary-tree-level-order-traversal/)

[二叉树求最大宽度](https://leetcode.cn/problems/maximum-width-of-binary-tree/solution/er-cha-shu-zui-da-kuan-du-by-leetcode-so-9zp3/)  
注意两端点间的 null 节点也需要计入宽度！  层序遍历 + （索引之差 + 1）



