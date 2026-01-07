import { useState } from 'react';
import { ethers } from 'ethers';

function App() {

  const [myWallet, setMyWallet] = useState("");
  const [balance, setBalance] = useState('');
  const [message, setMessage] = useState('');

  const [toAddress, setToAddress] = useState("");
  const [quantity, setQuantity] = useState("");

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

  return (
    <div>
      <p>
        My Wallet: <input type="text" onChange={evt => setMyWallet(evt.target.value)} />
        <input type="button" value="Connect" onClick={btnConnectClick} />
      </p>
      <p>Balance (ETH): {balance}</p>
      <hr />
      <p>
        To Address: <input type="text" onChange={evt => setToAddress(evt.target.value)} />
      </p>
      <p>
        Qty (ETH): <input type="text" onChange={evt => setQuantity(evt.target.value)} />
      </p>
      <p>
        <input type="button" value="Transfer" onClick={btnTransferClick} />
      </p>
      <hr />
      <p>{message}</p>
    </div >
  );
}

export default App;