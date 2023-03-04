# 系统设计面试资料
[grokking-the-system-design-interview PDF](https://vdoc.pub/download/grokking-the-system-design-interview-1sp2gd0atr0o)

[Course:Grokking Modern System Design Interview for Engineers & Managers](https://www.educative.io/courses/grokking-modern-system-design-interview-for-engineers-managers)

1. Requirements clarifications
2. System interface definition
3. Back-of-the-envelope estimation
4. Defining data model
5. High-level design(multiple application servers, separate servers ,distributed file storage system)
6. Detailed design(different approaches)
7. Identifying and resolving bottlenecks


# 短地址系统设计
- 功能：
  1. 短
  2. 唯一
  3. 有效期
  
- 技术上：
  1. HA
  2. 低延迟
  3. 安全性不能猜出来
  
- 资源：   
  storage  
  bandwidth  
  
- 接口：
- 加解密
- 失败点 
- cache: 2、8原则  