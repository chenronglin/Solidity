### 项目案例：使用Hardhat框架进行单元测试

设计一个智能合约，包含多个函数，使用Hardhat框架进行单元测试，确保合约的正确性和安全性。



以下是一个示例智能合约，其中包含多个函数，并使用Hardhat框架进行单元测试，以确保合约的正确性和安全性。合约实现了一个简单的投票系统，包括添加候选人、投票给候选人和查询候选人得票数的功能。

```solidity
// VotingContract.sol
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    uint256 public candidatesCount;

    constructor(string[] memory _candidateNames) {
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            addCandidate(_candidateNames[i]);
        }
    }

    function addCandidate(string memory _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint256 _candidateId) public {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        candidates[_candidateId].voteCount++;
    }
}
```

```solidity
// VotingContract.test.js (使用Hardhat框架进行单元测试)
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VotingContract", function () {
    let VotingContract;
    let votingContract;

    beforeEach(async () => {
        VotingContract = await ethers.getContractFactory("VotingContract");
        votingContract = await VotingContract.deploy(["Candidate 1", "Candidate 2"]);
        await votingContract.deployed();
    });

    it("should add candidates correctly", async function () {
        const candidate1 = await votingContract.candidates(1);
        const candidate2 = await votingContract.candidates(2);

        expect(candidate1.name).to.equal("Candidate 1");
        expect(candidate2.name).to.equal("Candidate 2");
    });

    it("should increase vote count when voting", async function () {
        await votingContract.vote(1);
        const candidate1 = await votingContract.candidates(1);
        expect(candidate1.voteCount).to.equal(1);
    });

    it("should not allow invalid candidate ID for voting", async function () {
        await expect(votingContract.vote(0)).to.be.revertedWith("Invalid candidate ID");
        await expect(votingContract.vote(3)).to.be.revertedWith("Invalid candidate ID");
    });
});
```

在上述示例中，我们创建了一个简单的投票合约`VotingContract`，其中包含添加候选人、投票给候选人和查询候选人得票数的功能。然后，我们使用Hardhat框架编写了测试脚本`VotingContract.test.js`，对合约的不同功能进行单元测试。

通过运行`npx hardhat test`命令，我们可以执行这些测试用例，确保合约的正确性和安全性。

**练习题：**
1. 解释示例合约中的每个函数的功能。
2. 解释测试脚本中的`beforeEach`函数的作用。
3. 如何运行Hardhat测试脚本以验证合约的正确性和安全性？