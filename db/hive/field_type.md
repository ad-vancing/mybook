[HiveDocumentation](https://cwiki.apache.org/confluence/display/Hive/Home#Home-HiveDocumentation)
[docs](https://www.docs4dev.com/docs/zh/apache-hive/3.1.1/reference/LanguageManual_Types.html)

# 字符型
STRING存储变长的文本，对长度没有限制
varchar（1到65355）长度上只允许在1-65355之间
Char The maximum length is fixed at 255.


# 整数型
https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types#LanguageManualTypes-NumericTypes
TINYINT ， SMALLINT， INT  / INTEGER ， BIGINT 
explain select 200;  --返回值类型：int 
大于BIGINT的数值，需要使用BD后缀以及Decimal(38,0)来处理

# 浮点型
FLOAT， DOUBLE
hive将字符串默认转换成double类型进行计算 `explain select '0.00407'*2500`
hive当中double是8个字节。float类型是占4个字节。

对于所有使用IEEE标准进行浮点编码系统中，都普遍存在如下问题：
double类型，0.2对应的真实结果是0.200000000001
float类型，0.2对应的是0.2000001
所以0.2f大于0.2d。

当float和doule进行比较时，会统一转换为double进行比较。
或者自己转：
```
select case when(cast(0.2 as float)=cast(0.2 as float)) then 0
            else -1 end;
```

## 定点型 DECIMAL(precision, scale)
Decimal在Hive 0.12.0 and 0.13.0之间是不兼容的，故0.12前的版本需要迁移才可继续使用
1）DECIMAL(9,8)代表最多9位数字，后8位是小数。此时也就是说，小数点前最多有1位数字，如果超过一位则会变成null。
2）如果不指定参数，那么默认是DECIMAL(10,0)，即没有小数位，此时0.82会变成1。

### 精度问题
double和decimal计算返回double，可能造成精度缺失。

两个declimal计算不会造成精度丢失，多个呢？
    ```
    select cast(100 as decimal(18,2))/cast(12 as decimal(18,2))*cast(6 as decimal(18,2))  --49.999998
    select cast(100 as decimal(18,2))*6/12  --50
    ```
hive中即使数值都是decimal，也有可能造成精度缺失 。
因为下一步的计算是以上一个计算结果为基础的，所以任何一部出现无法准确表达的数值时都可能造成精度缺失。
对于decimal类型来说，计算时应尽量让乘法在除法前计算，减少中间值无法精确表示的情况。

# 日期
时间戳转日期：
select from_unixtime(cast(operationtime/1000 as int), 'yyyy/MM/dd HH:mm:ss') from data_sync.test1_real;

org.apache.hadoop.hive.ql.parse.SemanticException:DATETIME type isn't supported yet. Please use DATE or TIMESTAMP instead

DATE类型只支持yyyy-MM-dd格式的数据。cast(date as string) 、cast(string as date) 、cast(date as timestamp) 
TIMESTAMPS表示UTC时间，格式为yyyy-MM-dd HH:mm:ss.fffffffff，即最多支持纳秒级。
INTERVAL，时间间隔在1.2.0之后版本支持，在2.2.0版本上进行了扩展，没用过。

Hive中的timestamp与时区无关，存储为UNIX纪元的偏移量。
Hive提供了用于timestamp和时区相互转换的便利UDF：to_utc_timestamp  和 from_utc_timestamp。

文本文件中的Timestamp必须使用`YYYY-MM-DD HH:MM:SS.fffffffff`的格式，如果使用其它格式，将它们声明为合适的类型（INT、FLOAT、STRING等）并使用UDF将它们转换为Timestamp。

# 集合类型
STRUCT
STRUCT 即结构体，通过相关的不同类型的数据来描述一个数据对象

ARRAY
ARRAY表示一组相同数据类型的集合，下标从零开始，可以用下标访问

MAP
MAP是一组键值对的组合，可以通过KEY访问VALUE

UNIONTYPE目前还没有完全支持。

# 其他
binary：二进制类型。       
BOOLEAN：表示二元的 true 或 false。

# 表的存储格式
https://blog.csdn.net/qq_31807385/article/details/84796880
