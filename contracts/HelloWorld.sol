// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title Hello World
/// @author LuizTools
/// @notice Contrato criado no capítulo 2 do livro.
/// @dev Criando com Remix
contract HelloWorld {
    string public message = "Hello World!";

    function helloWorld() public view returns (string memory) {
        return message;
    }
}
