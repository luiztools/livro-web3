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
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
