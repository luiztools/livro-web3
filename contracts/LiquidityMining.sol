// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ILPToken.sol";

contract LiquidityMining is Ownable {
    IERC20 public token;
    ILPToken public reward;

    mapping(address => uint) public balances; //user => balance
    mapping(address => uint) public checkpoints; //user => deposit timestamp

    uint public rewardFactor = 100;//base 10.000 = 100%
    uint public periodFactor = 30 * 24 * 60 * 60;//1 mês em segundos

    constructor(address tokenAddress, address rewardAddress) Ownable(msg.sender) {
        token = IERC20(tokenAddress);
        reward = ILPToken(rewardAddress);
    }

    function setRewardFactor(uint newRewardFactor) external onlyOwner isBlocked {
        rewardFactor = newRewardFactor;
    }

    function setPeriodFactor(uint newPeriodFactor) external onlyOwner isBlocked {
        periodFactor = newPeriodFactor;
    }

    modifier isBlocked(){
        require(token.balanceOf(address(this)) == 0, "Pool blocked");
        _;
    }

    function deposit(uint amount) external {
        require(amount > 0, "Invalid amount");
        require(balances[msg.sender] == 0, "Double deposit error");

        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] = amount;
        checkpoints[msg.sender] = block.timestamp;
    }

    function withdraw(uint amount) external {
        require(amount > 0, "Invalid amount");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        uint originalBalance = balances[msg.sender]; //necessário para recompensas
        balances[msg.sender] -= amount;
        rewardPayment(originalBalance, msg.sender); //paga as últimas recompensas devidas
        token.transfer(msg.sender, amount);
    }

    function _calculateRewards(uint balance) private view returns (uint) {
        uint timeFactor = (block.timestamp - checkpoints[msg.sender]) / periodFactor;
        if(timeFactor < 1) return 0;

        return balance * timeFactor * rewardFactor / 10000;
    }

    function rewardPayment(uint balance, address to) private {
        uint rewardAmount = _calculateRewards(balance);
        reward.mint(to, rewardAmount);
        checkpoints[to] = block.timestamp + 1;
    }

    function calculateRewards() public view returns (uint) {
        return _calculateRewards(balances[msg.sender]);
    }

    function poolBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }
}