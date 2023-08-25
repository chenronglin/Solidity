#### 项目名称：GreenEco Token

##### 目标：创建一个基于区块链技术的生态友好型能源解决方案，以促进可持续能源发展并减少环境污染。



#### 计划概述：

1. 代币类型：发行名为GreenEco Token的代币，采用以太坊区块链标准。代币将用于访问平台上的能源服务和激励机制。
2. 能源生产和存储：开发可再生能源设施，如太阳能板和风力涡轮，并将产生的能源存储在区块链上。
3. 区块链平台：创建一个区块链平台，用于记录能源生产和消费数据，确保透明性和可追溯性。
4. 用户参与：通过购买GreenEco Token，用户可以投资并获得能源服务，例如购买清洁能源或参与能源交易。
5. 奖励机制：设置激励机制，鼓励用户减少能源浪费，分享能源数据，并参与社区投票决策。
6. ICO筹款：通过ICO筹集资金，用于开发和扩展能源设施、区块链平台以及市场推广。



#### ICO合约主要功能：

1. **代币销售机制：** 定义用于购买代币的机制，通常涉及以太币或其他加密货币的支付。这可能包括确定代币价格、购买数量等。

2. **代币分发：** 确保在购买代币后，代币能够被正确分发给投资者。这包括更新余额、转移代币等操作。

3. **ICO管理：** 控制ICO的开启和关闭，防止在不适当的时间进行代币销售。

4. **退款机制：** 如果ICO未达到募资目标，可能需要提供退款机制，使投资者能够退还购买的代币并返还投资。

5. **事件通知：** 向投资者发送相关事件的通知，例如购买成功、代币分发等。

6. **所有权和余额管理：** 管理ICO合约的所有者，允许其执行特定操作，如提款和合约设置更改。

7. **数据追踪：** 跟踪已售出的代币数量，确保在ICO结束后没有额外的代币被销售。

8. **中止和恢复机制：** 为了应对安全问题或其他问题，可能需要添加中止和恢复合约的功能。

9. **数据查询：** 允许用户查询代币的当前价格、余额和其他与ICO相关的信息。

10.  **购买限额** : 限制单个用户最多购买数量。

    

#### 代币合约实现：

OpenZeppelin 是一个受欢迎的智能合约开发库，它提供了许多用于构建安全和标准合约的工具。以下是合约代码：

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// GreenEcoToken.sol
// 导入 OpenZeppelin 的合约库
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 定义代币合约，继承 ERC20 和 Ownable 合约
contract GreenEcoToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("GreenEco Token", "GET") {
        _mint(msg.sender, initialSupply);
    }
}

```

在此代码中，我们使用了 OpenZeppelin 提供的 `ERC20` 合约来创建代币合约，同时还使用了 `Ownable` 合约来管理权限。这大大简化了代币合约的开发，不再需要手动管理代币余额和转账等功能。请确保按照 OpenZeppelin 文档正确安装和使用库。



#### ICO合约实现

以下是一个使用 OpenZeppelin 实现的简单 ICO 合约示例，实现了上述ICO合约的主要功能：

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// Ico.sol
// 导入 OpenZeppelin 的合约库
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// 定义 ICO 合约
contract ICO is Ownable, ReentrancyGuard {
    IERC20 public tokenContract;   // 代币合约地址
    uint256 public tokenPrice;     // 单个代币的价格（wei）
    uint256 public tokensSold;     // 已售出的代币数量
    uint256 public minTokensToSell; // 最少售出的代币数量
    uint256 public maxTokensToSell; // 最多售出的代币数量
    uint256 public targetFunding;   // 目标募资金额
    uint256 public maxPurchaseAmount; // 每个用户购买的最大代币数量（以 tokenPrice 为单位）
    bool public isICOActive;       // ICO 是否激活状态

    event TokensPurchased(address indexed buyer, uint256 amount);

    constructor(
        address _tokenContract,
        uint256 _tokenPrice,
        uint256 _minTokensToSell,
        uint256 _maxTokensToSell,
        uint256 _targetFunding,
        uint256 _maxPurchaseAmount
    ) {
        tokenContract = IERC20(_tokenContract);  // 初始化代币合约地址
        tokenPrice = _tokenPrice;  // 初始化代币价格
        minTokensToSell = _minTokensToSell;  // 初始化最少售出代币数量
        maxTokensToSell = _maxTokensToSell;  // 初始化最多售出代币数量
        targetFunding = _targetFunding;      // 初始化目标募资金额
        maxPurchaseAmount = _maxPurchaseAmount; // 初始化每个用户购买的最大代币数量
        isICOActive = true;  // 初始化 ICO 激活状态
    }

    // 切换 ICO 的激活状态
    function toggleICO(bool _isActive) public onlyOwner {
        isICOActive = _isActive;
    }

    // 购买代币函数
    function buyTokens(uint256 _numberOfTokens) public payable nonReentrant {
        require(isICOActive, "ICO is not active");  // 确保 ICO 处于激活状态
        require(_numberOfTokens >= minTokensToSell && _numberOfTokens <= maxTokensToSell, "Invalid token amount");  // 确保购买的代币数量在允许范围内
        require(msg.value == _numberOfTokens * tokenPrice, "Incorrect value sent");  // 确保发送的以太币金额正确
        require(tokensSold + _numberOfTokens <= maxTokensToSell, "Exceeds available tokens for sale");  // 确保不超过最多售出代币数量
        require(address(this).balance <= targetFunding, "Exceeds target funding");  // 确保不超过目标募资金额
        require(_numberOfTokens <= maxPurchaseAmount, "Exceeds max purchase amount per user"); // 确保不超过每个用户的最大购买数量

        tokensSold += _numberOfTokens;  // 更新已售出代币数量
        tokenContract.transfer(msg.sender, _numberOfTokens);  // 转移代币给购买者
        emit TokensPurchased(msg.sender, _numberOfTokens);  // 触发代币购买事件
    }

    // 提取合约中的余额
    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // 提取合约中的代币
    function withdrawTokens(address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "Invalid address");
        uint256 remainingTokens = tokenContract.balanceOf(address(this));
        require(remainingTokens >= _amount, "Insufficient tokens in ICO contract");
        tokenContract.transfer(_to, _amount);
    }

    // 查询剩余可售代币数量
    function getAvailableTokens() public view returns (uint256) {
        return maxTokensToSell - tokensSold;
    }

    // 查询剩余的募资金额
    function getRemainingFunding() public view returns (uint256) {
        return targetFunding - address(this).balance;
    }

    // 查询 ICO 的激活状态
    function getICOStatus() public view returns (bool) {
        return isICOActive;
    }
}
```

我们使用 OpenZeppelin 的 `ReentrancyGuard` 合约来防止重入攻击。

补充购买限额需求：添加了一个名为 `maxPurchaseAmount` 的变量，用于设置每个用户购买的最大代币数量。在 `buyTokens` 函数中，我添加了一个新的 `require` 条件，确保购买数量不超过这个最大值。这样就限制了每个用户购买代币的上限为 `maxPurchaseAmount`。

