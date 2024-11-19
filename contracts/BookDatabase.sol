// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

struct Book {
    string title;
    string author;
    string isbn;
    uint16 pages;
    uint16 year;
}

/// @title Book Database
/// @author LuizTools
/// @notice Contrato criado no capítulo 2 do livro.
/// @dev Criando com Remix
contract BookDatabase {
    
    Book[] public books;

    function addBook(string calldata _title, string calldata _author, string calldata _isbn, uint16 _pages, uint16 _year) public {
        books.push(Book({
            title: _title,
            author: _author,
            isbn: _isbn,
            pages: _pages,
            year: _year
        }));
    }

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

    function deleteBook(uint index) public {
        delete books[index];
    }
}
