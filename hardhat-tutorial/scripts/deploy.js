const { ethers } = require("hardhat");
require("dotenv").config({path: ".env"});
const { CRYPTO_DEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const cryptoDevsNFTContract = CRYPTO_DEVS_NFT_CONTRACT_ADDRESS;

  //used as an abstraction to deploy smart contracts
  const cryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevToken");

  //deploy
  const deployedCryptoDevsTokenContract = await cryptoDevsTokenContract.deploy(cryptoDevsNFTContract);

  //print address of deployed contract
  console.log("Crypto Devs Token Address: ", deployedCryptoDevsTokenContract.address);
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
.then( () => process.exit(0))
.catch( (error) => {
  console.error(error);
  process.exit(1);
});
