新版的MySQL5.6.24上InnoDB引擎也加入了全文索引

使用全文索引的格式：  `MATCH (columnName) AGAINST ('string')`

# MySQL中有三种类型的全文检索：
1、自然语言检索：
全文检索中的默认类型。把查询字符串作为一个短语，如果有不少于50%的行匹配，则认为没有匹配的。想去掉50%的限制，可以修改文件myisam/ftdefs.h里的#define GWS_IN_USE GWS_PROB为#define GWS_IN_USE GWS_FREQ。
查询的字符串大小写不敏感，可以通过指定列的校验码为二进制的来实现大小写敏感。如字符集是latin1，可以指定校验码为latin1_bin。相关性排序的依据：行中的词总数、行中不同的词个数、集合中全部的词总数、查询到的行数。
只能进行单表查询，布尔检索可以进行多表查询。

2、布尔检索：
没有50%的限制。可以用包含特定意义的操作符，如 +、-、""，作用于查询字符串上。查询结果不是以相关性排序的。
[布尔模式ft_boolean_syntax](https://www.cnblogs.com/MaxElephant/p/9871132.html)
“+”表示必须包含
“-”表示必须排除
“>”表示出现该单词时增加相关性
“<”表示出现该单词时降低相关性
“*”表示通配符
“~”允许出现该单词，但是出现时相关性为负
“""”表示短语
no operation表示find word是可选的，如果出现，相关性会更高


3、查询括展检索：
对自然语言检索的一种改动(自动相关性反馈)，当查询短语太短时有用。先进行自然语言检索，然后把最相关的一些(系统变量ft_query_expansion_limit的值)行中的词添加到查询字符串中进行二次自然语言检索，查询得到的行作为结果返回。
————————————————
版权声明：本文为CSDN博主「navygong」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/navygong/article/details/4185769



# 创建支持中文的全文索引
必须指定  with parser ngram 关键字，否则innodb 默认的分词算法对 中文的支持很差。


[innodb 全文索引相关表以及参数](http://blog.itpub.net/29701030/viewspace-2286837/)
