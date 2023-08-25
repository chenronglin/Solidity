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
