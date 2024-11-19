//4.1
node - v

//4.2
npx create - react - app frontend - blockchain

//4.3
cd frontend - blockchain

//4.4
npm start

//4.5
import './App.css';

function App() {
    return (
        <div className="App">
            <h1>Hello World</h1>
        </div>
    );
}

export default App;

//4.6
npm install ethers

//4.7
import { useState } from 'react';
import { ethers } from 'ethers';

//4.8
const [myWallet, setMyWallet] = useState("");
const [balance, setBalance] = useState('');
const [message, setMessage] = useState('');

//4.9
return (
    <div>
        <p>
            My Wallet: <input type="text" onChange={evt => setMyWallet(evt.target.value)} />
            <input type="button" value="Connect" onClick={btnConnectClick} />
        </p>
        <p>
            Balance (ETH): {balance}
        </p>
        <hr />
        <p>
            {message}
        </p>
    </div >
);

//4.10
async function btnConnectClick() {
    if (!window.ethereum)
        return setMessage('No MetaMask');

    setMessage(`Trying to connect and load balance...`);
}

//4.11
async function btnConnectClick() {
    if (!window.ethereum)
        return setMessage("No MetaMask");

    setMessage("Trying to connect and load balance...");

    const provider = new ethers.BrowserProvider(window.ethereum);

    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) throw new Error("No MetaMask account allowed");

    const balance = await provider.getBalance(myWallet);
    setBalance(ethers.formatEther(balance.toString()));
    setMessage(``);
}

//4.12
const [toAddress, setToAddress] = useState("");
const [quantity, setQuantity] = useState("");

//4.13
<p>
  To Address: <input type="text" onChange={evt => setToAddress(evt.target.value)} />
</p>
<p>
  Qty (ETH): <input type="text" onChange={evt => setQuantity(evt.target.value)} />
</p>
<p>
  <input type="button" value="Transfer" onClick={btnTrasferClick} />
</p>
<hr />

//4.14
async function btnTransferClick() {
    setMessage(`Trying to transfer ETH ${quantity} to ${toAddress}...`);

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();

    const tx = await signer.sendTransaction({
        to: toAddress,
        value: ethers.parseEther(quantity)
    })
    await tx.wait();

    setMessage("Tx Hash: " + tx.hash);
}

//4.15
import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './abi.json';

const CONTRACT_ADDRESS = "0x8dd78c50505f86d29b48a27e0396ef4f65c36057";

//4.16
function App() {

    const [bookIndex, setBookIndex] = useState("0");
    const [message, setMessage] = useState("");

    async function btnSearchClick() {
        alert(bookIndex);
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
                <p>
                    {message}
                </p>
            </header>
        </div>
    );
}

//4.17
async function btnSearchClick() {
    if (!window.ethereum) return setMessage("No MetaMask found!");

    const provider = new ethers.BrowserProvider(window.ethereum);

    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) return setMessage("Wallet not found/allowed!");

    alert(bookIndex);
}

//4.18
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

//4.19
const [newBook, setNewBook] = useState({});

function onBookChange(evt) {
  setNewBook(prevState => ({ ...prevState, [evt.target.id]: evt.target.value }));
}

//4.20
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

//4.21
async function btnSaveClick(){
    alert(JSON.stringify(newBook));
}

//4.22
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