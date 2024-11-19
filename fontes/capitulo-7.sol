//7.1
pragma solidity ^0.8.26;

contract Carteira {
    mapping(address => uint256) public balances; //user => balance

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}

//7.2
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Carteira {
    IERC20 public immutable token;
    mapping(address => uint256) public balances; //user => balance

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);
    }

//7.3
function deposit(uint amount) external {
   token.transferFrom(msg.sender, address(this), amount);
   balances[msg.sender] += amount;
}

//7.4
function withdraw(uint amount) external {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    balances[msg.sender] -= amount;
    token.transfer(msg.sender, amount);
}

//7.5
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILPToken is IERC20 {
   function mint(address receiver, uint amount) external;
}

//7.6
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ILPToken.sol";

contract LiquidityToken is ILPToken, ERC20, Ownable {

}

//7.7
address public liquidityMining;

constructor() ERC20("LiquidityToken", "LPT") Ownable() {
  
}

//7.8
function setLiquidityMining(address contractAddress) public onlyOwner {
    liquidityMining = contractAddress;
}

//7.9
function mint(address receiver, uint amount) external{
    require(msg.sender == liquidityMining, "Unauthorized");
    _mint(receiver, amount);
}

//7.10
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ILPToken.sol";

contract LiquidityMining {
   IERC20 public token;
   ILPToken public reward;

   constructor(address tokenAddress, address rewardAddress) {
       token = IERC20(tokenAddress);
       reward = ILPToken(rewardAddress);
   }
}

//7.11
mapping(address => uint) public balances; 
mapping(address => uint) public checkpoints;

//7.12
uint public rewardFactor = 100;
uint public periodFactor = 30 * 24 * 60 * 60;

//7.13
function deposit(uint amount) external {
    require(amount > 0, "Invalid amount");
    require(balances[msg.sender] == 0, "Double deposit error");

    token.transferFrom(msg.sender, address(this), amount);
    balances[msg.sender] = amount;
    checkpoints[msg.sender] = block.timestamp;
}

//7.14
function _calculateRewards(uint balance) private view returns (uint) {
    uint timeFactor = (block.timestamp - checkpoints[msg.sender]) / periodFactor;
    if(timeFactor < 1) return 0;

    return balance * timeFactor * rewardFactor / 10000;
}

//7.15
function calculateRewards() public view returns (uint) {
    return _calculateRewards(balances[msg.sender]);
}

function poolBalance() external view returns (uint) {
    return token.balanceOf(address(this));
}

//7.16
function rewardPayment(uint balance, address to) private {
    uint rewardAmount = _calculateRewards(balance);
    reward.mint(to, rewardAmount);
    checkpoints[to] = block.timestamp + 1;
}

//7.17
function withdraw(uint amount) external {
    require(amount > 0, "Invalid amount");
    require(balances[msg.sender] >= amount, "Insufficient balance");

    uint originalBalance = balances[msg.sender]; //necessário para recompensas
    balances[msg.sender] -= amount;
    rewardPayment(originalBalance, msg.sender); //paga as últimas recompensas devidas
    token.transfer(msg.sender, amount);
}

//7.18
import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidityMining is Ownable {

//7.19
constructor(address tokenAddress, address rewardAddress) Ownable() {
    token = IERC20(tokenAddress);
    reward = ILPToken(rewardAddress);
}

//7.20
function setRewardFactor(uint newRewardFactor) external onlyOwner {
    rewardFactor = newRewardFactor;
}

function setPeriodFactor(uint newPeriodFactor) external onlyOwner {
    periodFactor = newPeriodFactor;
}

//7.21
modifier isBlocked(){
    require(token.balanceOf(address(this)) == 0, "Pool blocked");
    _;
}

//7.22
function setRewardFactor(uint newRewardFactor) external onlyOwner isBlocked {
    rewardFactor = newRewardFactor;
}

function setPeriodFactor(uint newPeriodFactor) external onlyOwner isBlocked {
    periodFactor = newPeriodFactor;
}

//7.23
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./ILPToken.sol";


contract LiquidityToken is ILPToken, ERC20, ERC20Burnable, Ownable {

//7.24
receive() payable external { }

//7.25
uint public constant weiLpRatio = 100;

function proofOfReserves() public view returns (int) {
    return int(address(this).balance) - int(totalSupply() * weiLpRatio);
}

//7.26
function swapEthToLpt() external payable {
    require(msg.value > 0, "Invalid value");
    _mint(msg.sender, msg.value * weiLpRatio);
}

//7.27
function swapLptToEth(uint amountInLpt) external {
    require(amountInLpt > 0, "Invalid amount");
    require(balanceOf(msg.sender) >= amountInLpt, "Insufficient balance");
    uint weis = amountInLpt / weiLpRatio;
    _burn(msg.sender, weis * weiLpRatio);
    payable(msg.sender).transfer(weis);
}