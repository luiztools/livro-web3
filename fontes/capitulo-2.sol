//2.1
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

//2.2
/// @title Título do seu contrato
/// @author Nome do autor
/// @notice Explique o que o contrato faz
/// @dev Detalhes adicionais para devs

//2.3
contract HelloWorld {
    
}

//2.4
contract HelloWorld {
    string public message = "Hello World!";
}

//2.5
contract HelloWorld {
    string public message = "Hello World!";

    function helloWorld() public view returns (string memory) {
        return message;
    }
}

//2.6
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BookDatabase {
    
}

//2.7
struct Book {
    
}

//2.8
struct Book {
    string title;
    string author;
    string isbn;
    uint16 pages;
    uint16 year;
}

//2.9
Book[] public books;

//2.10
function addBook(string calldata _title, string calldata _author, string calldata _isbn, uint16 _pages, uint16 _year) public {
    books.push(Book({
        title: _title,
        author: _author,
        isbn: _isbn,
        pages: _pages,
        year: _year
    }));
}

//2.11
function updateBook(uint index, string calldata _author, uint16 _pages, uint16 _year) public {
    Book memory updatedBook = books[index];

    if(bytes(_author).length > 0)
        updatedBook.author = _author;

    if(_pages > 0)
        updatedBook.pages = _pages;

    if(_year > 0)
        updatedBook.year = _year;

    books[index] = updatedBook;
}

//2.12
function deleteBook(uint index) public {
    delete books[index];
}