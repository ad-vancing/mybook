
there are two main programming languages, [Solidity](https://docs.soliditylang.org/en/v0.8.19/) and JavaScript.   
Learn Solidity primarily to make smart contracts, and learn JavaScript to test them.

https://github.com/OpenZeppelin/openzeppelin-contracts

# variable of type
- 值类型：bool、int/uint、address、fixed byte array、fixed float、enum、function

- 引用类型：Array(string、dynamic byte array)、struct、mapping

## int
int = int256

## SafeMath库使用
0.8之后不需要了（会报错而不是溢出变小）

## address
public key -> keccak256哈希 后取最后20 byte（40bit of hexadecimal）得到。

- 外部账户 EOA externally owned account

- contract account

# storage
- storage 成员变量默认，网络中的。by reference passing

- memory 函数入参数默认，内部局部变量、返回值。by value passing ，也可以用storage转换

# key words
mint

require

error

revert

send

event emitted listen by client such as web3.js

modifiers

对状态变量有修改的不能用 view关键字

变量默认可见性是私有的


# visiablities
- external

- public

- internal

- private


# type
- pure

- view

- payable

- constant


# return

# modifier


# commom func
