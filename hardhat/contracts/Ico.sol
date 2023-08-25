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