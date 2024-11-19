import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './abi.json';

const CONTRACT_ADDRESS = "0x8dd78c50505f86d29b48a27e0396ef4f65c36057";

function App() {

  const [bookIndex, setBookIndex] = useState("0");
  const [message, setMessage] = useState("");
  const [newBook, setNewBook] = useState({});

  function onBookChange(evt) {
    setNewBook(prevState => ({ ...prevState, [evt.target.id]: evt.target.value }));
  }

  async function btnSearchClick() {
    if (!window.ethereum) return setMessage("No MetaMask found!");

    const provider = new ethers.BrowserProvider(window.ethereum);

    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) return setMessage("Wallet not found/allowed!");

    try {
      const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);
      const book = await contract.books(bookIndex);
      alert(`Title: ${book.title}
        Author: ${book.author}
        ISBN: ${book.isbn}
        Pages: ${book.pages}
        Year: ${book.year}`)
    } catch (err) {
      setMessage(err.message);
    }
  }

  async function btnSaveClick(){
    setMessage("Accept the transaction at MetaMask...");
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
    const tx = await contract.addBook(newBook.title, newBook.author, newBook.isbn, newBook.pages, newBook.year);
    setMessage("Sending a new book to BookDatabase...wait...");
    await tx.wait();
    setMessage("Tx: " + tx.hash);
  }

  return (
    <div>
      <header>
        <p>
          <label>Book Index: <input type="number" value={bookIndex} onChange={evt => setBookIndex(evt.target.value)} /></label>
        </p>
        <p>
          <input type="button" value="Search" onClick={btnSearchClick} />
        </p>
        <hr />
        <p>
          <label>Title: <input type="text" id="title" value={newBook.title} onChange={onBookChange} /></label>
        </p>
        <p>
          <label>Author: <input type="text" id="author" value={newBook.author} onChange={onBookChange} /></label>
        </p>
        <p>
          <label>ISBN: <input type="text" id="isbn" value={newBook.isbn} onChange={onBookChange} /></label>
        </p>
        <p>
          <label>Year: <input type="text" id="year" value={newBook.year} onChange={onBookChange} /></label>
        </p>
        <p>
          <label>Pages: <input type="text" id="pages" value={newBook.pages} onChange={onBookChange} /></label>
        </p>
        <p>
          <input type="button" value="Save" onClick={btnSaveClick} />
        </p>
        <p>
          {message}
        </p>
      </header>
    </div>
  );
}

export default App;
