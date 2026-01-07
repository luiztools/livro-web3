// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILPToken is IERC20 {
    function mint(address receiver, uint amount) external;
}