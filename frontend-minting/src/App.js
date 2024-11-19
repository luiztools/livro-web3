import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './abi.json';

function App() {
  const CONTRACT_ADDRESS = "0x29192156887812feead48c668d403b7074e6e039";

  const [message, setMessage] = useState("");
  const [image, setImage] = useState("");

  async function btnMintClick() {
    if (!window.ethereum) return setMessage("No MetaMask found!");

    const provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) return setMessage("Wallet not found/allowed!");

    try {
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
      const tx = await contract.mint({ value: ethers.parseEther("0.001") });
      setMessage("Minting your NFT...wait...");

      const receipt = await tx.wait();
      const tokenId = ethers.toBigInt(receipt.logs[0].topics[3]);
      setMessage(`Congrats, you minted your NFT (below). Id: ${tokenId}\n Tx: ${tx.hash}`);

      const gatewayUrl = "https://maroon-relaxed-rattlesnake-748.mypinata.cloud/ipfs/";
      const tokenUri = await contract.tokenURI(tokenId);
      const response = await fetch(tokenUri.replace("ipfs://", gatewayUrl));
      const data = await response.json();
      setImage(data.image.replace("ipfs://", gatewayUrl));
    }
    catch (err) {
      setMessage(err.message);
    }
  }

  return (
    <div className="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
      <header className="mb-auto">
        <div>
          <h3 className="float-md-start mb-0">My NFT Collection</h3>
          <nav className="nav nav-masthead justify-content-center float-md-end">
            <a className="nav-link fw-bold py-1 px-0 active" aria-current="page" href="#">Home</a>
            <a className="nav-link fw-bold py-1 px-0" href="#">About</a>
          </nav>
        </div>
      </header>

      <main className="px-3 mt-5">
        <h1>Mint your NFT</h1>
        <p className="lead">Pay ETH 0.001 and earn a Shiba figure just connecting your MetaMask below.</p>
        <p className="lead">
          <a href="#" onClick={btnMintClick} className="btn btn-lg btn-secondary fw-bold border-white bg-white mt-5">
            <img src="https://luiztools.com.br/img/metamask.svg" alt="MetaMask logo" width="48" />
            Mint with MetaMask
          </a>
        </p>
        <p className="lead">
          {message}
        </p>
        {
          image
            ? <img src={image} width={270} />
            : <></>
        }
      </main>
    </div>
  );
}

export default App;
