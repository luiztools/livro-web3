// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ILPToken.sol";

contract LiquidityToken is ILPToken, ERC20, Ownable {

    address public liquidityMining;

    constructor() ERC20("LiquidityToken", "LPT") Ownable(msg.sender) {
        
    }

    function setLiquidityMining(address contractAddress) public onlyOwner {
        liquidityMining = contractAddress;
    }

    function mint(address receiver, uint amount) external{
        require(msg.sender == liquidityMining, "Unauthorized");
        _mint(receiver, amount);
    }
}