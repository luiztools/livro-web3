// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Carteira {
    IERC20 public immutable token;
    mapping(address => uint256) public balances; //user => balance

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);
    }

    function deposit(uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
    }
}
