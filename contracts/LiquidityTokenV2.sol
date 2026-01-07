// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./ILPToken.sol";

contract LiquidityToken is ILPToken, ERC20, ERC20Burnable, Ownable {

    address public liquidityMining;

    constructor() ERC20("LiquidityToken", "LPT") Ownable(msg.sender) { }

    function setLiquidityMining(address contractAddress) public onlyOwner {
        liquidityMining = contractAddress;
    }

    function mint(address receiver, uint amount) external{
        require(msg.sender == liquidityMining, "Unauthorized");
        _mint(receiver, amount);
    }

    receive() payable external { }

    uint public constant weiLpRatio = 100;

    //>= 0 está saudável
    function proofOfReserves() public view returns (int) {
        return int(address(this).balance) - int(totalSupply() * weiLpRatio);
    }

    function swapEthToLpt() external payable {
        require(msg.value > 0, "Invalid value");
        _mint(msg.sender, msg.value * weiLpRatio);
    }

    function swapLptToEth(uint amountInLpt) external {
        require(amountInLpt > 0, "Invalid amount");
        require(balanceOf(msg.sender) >= amountInLpt, "Insufficient balance");
        uint weis = amountInLpt / weiLpRatio;
        _burn(msg.sender, weis * weiLpRatio);
        payable(msg.sender).transfer(weis);
    }
}