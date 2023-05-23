// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// Import the ERC20 token contract
import "./erc20.sol";

contract NFTMarketplace {
    struct NFT {
        address owner;
        bool isForSale;
        uint price;
    }

    address public TokenAd;
    uint public sellAmount;

    mapping(uint => NFT) public nfts;
    mapping(address => uint) public balances;

    constructor(address _TokenA) {
        TokenAd = _TokenA;
    }

    function mintNFT(uint _nftId, uint _price) external payable {
        require(nfts[_nftId].owner == address(0), "NFT already exists");
        require(msg.value == 0.1 ether, "Insufficient Ether sent");

        nfts[_nftId] = NFT({
            owner: msg.sender,
            isForSale: false,
            price: _price
        });
    }

    function NFTSale(uint _nftId, uint _sellAmount) external {
        require(nfts[_nftId].owner == msg.sender, "Not the NFT owner");
        require(!nfts[_nftId].isForSale, "NFT is already for sale");
        require(_sellAmount > 0, "Sell amount must be greater than 0");

        sellAmount = _sellAmount;
        nfts[_nftId].isForSale = true;
    }

    function buyNFT(uint _nftId) external {
        NFT storage nft = nfts[_nftId];
        require(nft.isForSale, "NFT is not for sale");
        require(nft.price > 0, "NFT price must be greater than 0");

        // Transfer ERC20 tokens from buyer to seller
        TokenA AToken = TokenA(TokenAd);
        AToken.transferFrom(msg.sender, nft.owner, 1); // Assuming 1 ERC20 token per NFT

        // Transfer Ether from buyer to seller
        balances[nft.owner] += nft.price;

        // Update NFT details
        nft.owner = msg.sender;
        nft.isForSale = false;
    }

    // Function to withdraw funds (Ether and ERC20 tokens)
    function withdrawFunds() external {
        uint amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");

        balances[msg.sender] = 0;

        // Transfer Ether
        payable(msg.sender).transfer(amount);

        // Transfer ERC20 tokens
        TokenA AToken = TokenA(TokenAd);
        AToken.transfer(msg.sender, amount);
    }
}
