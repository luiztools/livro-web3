//9.1
npm init -y
npm install -D hardhat

//9.2
npx hardhat --init

//9.3
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract HelloWorld {
   string public message = "Hello World!";

   function helloWorld() public view returns (string memory) {
       return message;
   }
}

//9.4
import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

//9.5
describe("HelloWorld", () => {

});

//9.6
it("Should Hello the world", async () => {
  const helloWorld = await ethers.deployContract("HelloWorld");
  expect(await helloWorld.helloWorld()).equal("Hello World!");
});

//9.7
npx hardhat test mocha

//9.8
npm install dotenv

//9.9
PRIVATE_KEY=sua chave privada
RPC_NODE=sua URL da Infura aqui
CHAIN_ID=11155111

//9.10
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const HelloWorldModule = buildModule("HelloWorldModule", (m) => {
  const contract = m.contract("HelloWorld");
  return { contract };
});

export default HelloWorldModule;

//9.11
import "dotenv/config";
//…
  networks: {
    sepolia: {
      type: "http",
      chainType: "l1",
      chainId: Number(process.env.CHAIN_ID),
      url: configVariable("RPC_NODE"),
      accounts: [configVariable("PRIVATE_KEY")],
    }
  }
});

//9.12
npx hardhat ignition deploy ignition/modules/HelloWorld.ts --network sepolia

//9.13
API_KEY=sua API Key da EtherScan

//9.14
  verify: {
    etherscan: {
      apiKey: process.env.API_KEY
    }
  }
});

//9.15
npx hardhat verify etherscan --network sepolia <contrato>

//9.16
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
   constructor() ERC20("MyToken", "MTK") {}
}

//9.17
npm install -D @openzeppelin/contracts

//9.18
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

//9.19
contract MyContract {
    Book[] books;
    mapping(uint => uint) bookIndex;//id to index

    function updateBook(uint id, string calldata newTitle) public {
        uint index = bookIndex[id];
        books[index].title = newTitle;
    }
}

//9.20
library JKPLibrary {
    struct Player {
        address wallet;
        uint32 wins;
    }
}

//9.21
import "./JKPLibrary.sol";

contract JoKenPo {
    JKPLibrary.Player[] public players;

    //...

//9.22
const MetaCoin = await ethers.getContractFactory("MetaCoin", {
  libraries: {
    SafeMath: "0x...",
  },
});
const metaCoin = await MetaCoin.deploy();

//9.23
solidity: {
  profiles: {
    default: {
      version: "0.8.28",
    },
    production: {
      version: "0.8.28",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
},

//9.24
uint128 x = 0;
uint256 y = 1;
uint128 z = 2;

//9.25
uint128 x = 0;
uint128 z = 2;
uint256 y = 1;