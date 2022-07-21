//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICryptoDevs {
    //return tokenID owned by owner at given index of token list
    //use balanceOf to enumerate all of owner tokens
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256 tokenId);

    //return the number of tokens in owner account
    function balanceOf(address owner) external view returns(uint256 balance);
}