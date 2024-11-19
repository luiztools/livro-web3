//9.1
npm init -y
npm install -D hardhat

//9.2
npx hardhat init

//9.3
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract HelloWorld {
   string public message = "Hello World!";

   function helloWorld() public view returns (string memory) {
       return message;
   }
}

//9.4
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

//9.5
describe("HelloWorld", () => {

});

//9.6
async function deployFixture() {
  const [owner, otherAccount] = await ethers.getSigners();
  const HelloWorld = await ethers.getContractFactory("HelloWorld");
  const helloWorld = await HelloWorld.deploy();
  return { helloWorld, owner, otherAccount };
}

//9.7
it("Should Hello the world", async () => {
  const { helloWorld } = await loadFixture(deployFixture);
  expect(await helloWorld.helloWorld()).equal("Hello World!");
});

//9.8
npx hardhat test

//9.9
npm install dotenv

//9.10
SECRET=suas 12 palavras aqui separadas por espaços
RPC_URL=sua URL da Infura aqui

//9.11
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const HelloWorldModule = buildModule("HelloWorldModule", (m) => {
  const contract = m.contract("HelloWorld");
  return { contract };
});

export default HelloWorldModule;

//9.12
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import dotenv from 'dotenv';
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.26",
  networks: {
    sepolia: {
      url: process.env.RPC_NODE,
      chainId: 11155111,
      accounts: {
        mnemonic: process.env.SECRET
      }
    }
  }
};

export default config;

//9.13
npx hardhat ignition deploy ignition/modules/HelloWorld.ts --network sepolia

//9.14
API_KEY=sua API Key da EtherScan

//9.15
etherscan: {
  apiKey: process.env.API_KEY
}

//9.16
npx hardhat verify --network sepolia <contrato>

//9.17
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
   constructor() ERC20("MyToken", "MTK") {}
}

//9.18
npm install -D @openzeppelin/contracts

//9.19
struct Book {
   uint id;
   string title;
   uint16 year;
}

contract MyContract {

   Book[] books;

   function updateBook(uint id, string calldata newTitle) public {
       for(uint i=0; i < books.length; i++){
           if(books[i].id == id){
               books[i].title = newTitle;
               break;
           }
       }
   }
}

//9.20
contract MyContract {
    Book[] books;
    mapping(uint => uint) bookIndex;//id to index

    function updateBook(uint id, string calldata newTitle) public {
        uint index = bookIndex[id];
        books[index].title = newTitle;
    }
}

//9.21
library JKPLibrary {
    struct Player {
        address wallet;
        uint32 wins;
    }
}

//9.22
import "./JKPLibrary.sol";

contract JoKenPo {
    JKPLibrary.Player[] public players;

    //...

//9.23
const MetaCoin = await ethers.getContractFactory("MetaCoin", {
  libraries: {
    SafeMath: "0x...",
  },
});
const metaCoin = await MetaCoin.deploy();

//9.24
solidity: {
  version: "0.8.26",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
},

//9.25
uint128 x = 0;
uint256 y = 1;
uint128 z = 2;

//9.26
uint128 x = 0;
uint128 z = 2;
uint256 y = 1;