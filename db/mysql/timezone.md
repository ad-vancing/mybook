关于数据库时区问题

# 数据库安装
[数据库时区设置](https://blog.csdn.net/qq_29752857/article/details/102948830)
show variables like'%time_zone';

这时候谨慎设置 datetime、timestamp 类型 默认值为 CURRENT_TIMESTAMP

# 数据库查询
在jdbc url 后加 `/?serverTimezone=Asia/Shanghai`


# json转换
@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
