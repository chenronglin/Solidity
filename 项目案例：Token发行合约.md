### **项目案例**：Token发行合约

设计一个简单的Token（代币）发行合约，其中包括以下功能：

- 可以创建具有初始总供应量的代币。
- 支持代币转账和余额查询。
- 触发事件以记录代币转账。

以下是一个基本的代币合约示例，包括创建代币、转账和余额查询功能：

```solidity
// 合约定义
pragma solidity ^0.8.0;

contract SimpleToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0), "Invalid address");
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
```

在这个合约中，我们通过构造函数初始化代币的名称、符号、小数位数和初始总供应量。合约提供了`transfer`、`approve`和`transferFrom`函数，用于代币的转账和授权操作。`balanceOf`映射用于存储用户的代币余额，`allowance`映射用于存储授权额度。合约还定义了`Transfer`事件，以记录代币转账。

你可以使用Remix等工具部署并测试这个合约，然后使用Web3.js或其他前端界面与合约进行交互，进行代币的转账和余额查询操作。

练习题：
1. 解释代币合约中的`approve`和`transferFrom`函数的作用。
2. 列举并说明代币合约中的主要数据结构，包括`balanceOf`和`allowance`映射。



###  拓展项目：代币发行DApp
设计一个简单的代币发行DApp，其中包括以下功能：

* 允许用户创建代币，输入代币名称、符号、小数位数和初始总供应量。
* 允许用户进行代币转账，显示转账记录。
* 显示用户的代币余额和已授权额度。

学生可以根据所学知识，实现上述功能。这个项目案例将帮助他们将代币合约的设计和实现应用于实际问题中，加深对智能合约编写的理解。

在本章的教学过程中，通过讲解、示例代码和练习题，引导学生深入了解如何设计和实现简单的代币发行合约，培养他们在智能合约开发中的实际能力。