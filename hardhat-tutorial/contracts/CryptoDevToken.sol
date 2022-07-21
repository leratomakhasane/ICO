//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable{
    //price of crypto dev token
    uint256 public constant tokenPrice = 0.001 ether;

    //Each NFT gives the user 10 tokens represented as 10 * (10 ** 18) as ERC20 tokens are represented by smallest denominator
    uint256 public constant tokensPerNFT = 10 * 10**18;

    //max total supply is 10000 for crypto dev tokens
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    //instance of CryptoDevsNFT contract
    ICryptoDevs CryptoDevsNFT;

    //keep track of which tokenIds have been claimed
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD"){
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    //Mint amount number of CryptoDevTokens, msg.sender should be equal/greater than tokenPrice*amount

    function mint(uint256 amount) public payable {
        //should be equal or greater than tokenPrice*amount
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");

        //total tokens+amount <=10000 otherwise revert the transaction
        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply available."
        );

        //internal function from Openzeppelin's ERC20 contract
        _mint(msg.sender, amountWithDecimals);
    }

    //balance of Crypto Dev NFT's owned by the sender should be greater than 0
    //Tokens should not be claimed for all the NFT's owned by the sender

    function claim() public {
        address sender = msg.sender;

        //number of CryptoDev NFT's held by the sender address
        uint256 balance = CryptoDevsNFT.balanceOf(sender);

        //if balance is zero, revert the transaction
        require(balance > 0, "You dont own any Crypto Dev NFTs");

        //keep track of number of unclaimed tokenIds
        uint256 amount = 0;

        //get the tokenId owned by sender at given index of it's token list
        for(uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);

            //if not claimed, increase the amount
            if(!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        //if all tokenIds are claimed, revert the transaction
        require(amount > 0, "You have already claimed all the tokens");

        //call internal function from ERC20 contract, MInt (amount*10) tokens for each NFT
        _mint(msg.sender, amount * tokensPerNFT);
    }

    //withdraw all Ether and tokens sent to the contract, wallet connected must be the owners

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    
    receive() external payable {}

    fallback() external payable {}
}