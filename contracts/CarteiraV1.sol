// SPDX-License-Identifier: MIT

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
