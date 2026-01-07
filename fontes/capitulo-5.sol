//5.1
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract LuizCoin {
   
}

//5.2
string private constant _name = "LuizCoin";
string private constant _symbol = "LUC";
uint8 private constant _decimals = 18;
uint256 private constant _totalSupply = 10000 * 10 ** _decimals;

//5.3
mapping(address => uint256) private _balances;

//5.4
constructor() {
    _balances[msg.sender] = _totalSupply;
}

//5.5
function name() public view returns (string memory) {
    return _name;
}

function symbol() public view returns (string memory) {
    return _symbol;
}

function decimals() public view returns (uint8) {
    return _decimals;
}

function totalSupply() public view returns (uint) {
    return _totalSupply;
}

//5.6
function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
}

//5.7
function transfer(address to, uint256 value) public returns (bool) {
    require(balanceOf(msg.sender) >= value, "Insuficient balance");
    _balances[msg.sender] -= value;
    _balances[to] += value;
    emit Transfer(msg.sender, to, value);
    return true;
}

//5.8
event Transfer(address indexed from, address indexed to, uint256 value);

//5.9
mapping(address => mapping(address => uint256)) private _allowances;

//5.10
function allowance(address _owner, address _spender) public view returns (uint256){
    return _allowances[_owner][_spender];
}

//5.11
event Approval(address indexed owner, address indexed spender, uint256 value);

function approve(address spender, uint256 value) public returns (bool) {
    _allowances[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
}

//5.12
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(balanceOf(from) >= value, "Insufficient balance");
    require(allowance(from, msg.sender) >= value, "Insufficient allowance");
    
    _allowances[from][msg.sender] -= value;
    _balances[from] -= value;
    _balances[to] += value;
    
    emit Transfer(from, to, value);
    return true;
}

//5.13
//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FaucetERC20 {

}

//5.14
IERC20 immutable public tokenContract;
mapping(address => uint) public nextTry;

uint constant INTERVAL = 86400;//24h
uint constant AMOUNT = 0.1 ether;

//5.15
constructor(address tokenAddress){
    tokenContract = IERC20(tokenAddress);
}

//5.16
function withdraw() external {
    require(block.timestamp > nextTry[msg.sender], "Invalid withdraw");
    nextTry[msg.sender] = block.timestamp + INTERVAL;
    tokenContract.transfer(msg.sender, AMOUNT);
}