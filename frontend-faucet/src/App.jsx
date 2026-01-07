import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './abi.json';

function App() {
  const CONTRACT_ADDRESS = "0x7baef326dbd7cc9173d39c7b4652ef60d8138bf4";

  const [message, setMessage] = useState("");

  async function btnConnectClick() {
    if (!window.ethereum) return setMessage("No MetaMask found!");

    const provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) return setMessage("Wallet not found/allowed!");

    try {
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
      const tx = await contract.withdraw();
      setMessage("Withdrawing LuizCoins...wait...");
      await tx.wait();
      setMessage("Tx: " + tx.hash);
    }
    catch (err) {
      setMessage(err.message);
    }
  }

  return (
    <div className="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
      <header className="mb-auto">
        <div>
          <h3 className="float-md-start mb-0">LuizCoin Faucet</h3>
          <nav className="nav nav-masthead justify-content-center float-md-end">
            <a className="nav-link fw-bold py-1 px-0 active" aria-current="page" href="#">Home</a>
            <a className="nav-link fw-bold py-1 px-0" href="#">About</a>
          </nav>
        </div>
      </header>

      <main className="px-3 mt-5">
        <h1>Get your LuizCoins</h1>
        <p className="lead">Once a day, earn 0.1 coins for free just connecting your MetaMask below.</p>
        <p className="lead">
          <a href="#" onClick={btnConnectClick} className="btn btn-lg btn-secondary fw-bold border-white bg-white mt-5">
            <img src="https://luiztools.com.br/img/metamask.svg" alt="MetaMask logo" width="48" />
            Connect MetaMask
          </a>
        </p>
        <p className="lead">
          {message}
        </p>
      </main>
    </div>
  )
}

export default App
