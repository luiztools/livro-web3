//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FaucetERC20 {

    IERC20 immutable public tokenContract;
    mapping(address => uint) public nextTry;

    uint constant INTERVAL = 86400;//24h
    uint constant AMOUNT = 0.1 ether;

    constructor(address tokenAddress){
        tokenContract = IERC20(tokenAddress);
    }

    function withdraw() external {
        require(block.timestamp > nextTry[msg.sender], "Invalid withdraw");
        nextTry[msg.sender] = block.timestamp + INTERVAL;
        tokenContract.transfer(msg.sender, AMOUNT);
    }
}