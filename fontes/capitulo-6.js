//6.25
<title>My NFT Collection</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<link href="minting.css" rel="stylesheet" />

//6.26
import { useState } from 'react';
import { ethers } from 'ethers';
import ABI from './abi.json';

function App() {
  const CONTRACT_ADDRESS = "0x75a5c4b84b2b43d28481ff7f329eb15f2ec6fbdd";

  const [message, setMessage] = useState("");
  const [image, setImage] = useState("");

//6.28
async function btnMintClick() {
    if (!window.ethereum) return setMessage("No MetaMask found!");
  
    const provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts");
    if (!accounts || !accounts.length) return setMessage("Wallet not found/allowed!");
  
    try {
      //lógica da transação aqui
    }
    catch (err) {
      setMessage(err.message);
    }
}

//6.29
const signer = await provider.getSigner();
const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
const tx = await contract.mint({ value: ethers.parseEther("0.001") });
setMessage("Minting your NFT...wait...");

//6.30
const receipt = await tx.wait();
const tokenId = ethers.toBigInt(receipt.logs[0].topics[3]);
setMessage(`Congrats, you minted your NFT (below). Id: ${tokenId}\n Tx: ${tx.hash}`);

//6.31
const gatewayUrl = "https://maroon-relaxed-rattlesnake-748.mypinata.cloud/ipfs/";
const tokenUri = await contract.tokenURI(tokenId);
const response = await fetch(tokenUri.replace("ipfs://", gatewayUrl));
const data = await response.json();
setImage(data.image.replace("ipfs://", gatewayUrl));