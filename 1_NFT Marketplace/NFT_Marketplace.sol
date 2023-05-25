// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MarketPlace is ERC721
{
    IERC20 ERC20Token; // Our Custom Token
    uint nftId = 1; // NFT ID start from 1
    uint i = 0; // its for the For Loop
    address nftOwner; //store the address of NFT buyer

    //check NFT is On Sell or Not.
    mapping(uint => bool) public isOn_Sell; 

    //Map the seller address : nftId : sellAmount
    mapping(address => mapping(uint => uint)) SellList;
    
    //Map nftId : sellAmount
    mapping(uint => uint) public IdAmount;
    
    //Map nftOwner address : sellAmount
    mapping(address => uint) public walletBalance;

    uint[][] onSale; //2D array which store nftId and its Amount;

    
    constructor(address _ERC20Token) ERC721("MyNFT", "mnft") 
    {
        ERC20Token = IERC20(_ERC20Token);
    }

    function safeMint() public payable
    {
        require(msg.value == 0.1 ether,"Amount must be 0.1 ether");
        _safeMint(msg.sender,nftId);
        nftId++;
    }

    mapping(uint => mapping(uint => uint[])) public arrayIndex;
    mapping (uint256 => uint256) public checkCounterWithNft;

    uint256 public counter = 1;
    uint256 public arrayCounter = 0;


    function sellNFT(uint _nftId, uint _amount) public 
    {
        require(balanceOf(msg.sender) >= 1, "Sorry, you don't have enough NFTs");
        require(msg.sender == ownerOf(_nftId), "Sorry, you don't own this NFT");
        require(_amount > 0, "Price must be greater than zero");
        require(!isOn_Sell[_nftId], "Already on sell list");

        nftOwner = msg.sender;

        SellList[nftOwner][_nftId] = _amount;
        IdAmount[_nftId] = _amount;
        isOn_Sell[_nftId] = true;
        onSale.push([_nftId, _amount]);
        arrayIndex[counter][_nftId] = onSale[arrayCounter];
        checkCounterWithNft[_nftId] = counter;
        counter ++;
        arrayCounter ++;
    }

    function buyNFT(uint _nftId, uint _amount, uint256 _counter) payable public returns (bool) 
    {
        require(IERC20(ERC20Token).balanceOf(msg.sender) >= _amount, "Not enough balance");
        require(msg.sender != ownerOf(_nftId), "You can't buy your NFT");
        require(ERC20Token.balanceOf(msg.sender) >= _amount, "Not enough balance");

    if (_amount == IdAmount[_nftId]) 
    {
        IERC20(ERC20Token).transferFrom(msg.sender, address(this), _amount);
        transferFrom(nftOwner, msg.sender, _nftId);
        walletBalance[nftOwner] += _amount;
        isOn_Sell[_nftId] = false;

        // Find the index of the NFT in the onSale array
        uint indexToRemove = findIndexInOnSale(_nftId);

        // Remove the NFT from the onSale array by swapping with the last element and reducing the array length
        uint lastIndex = onSale.length - 1;
        onSale[indexToRemove] = onSale[lastIndex];
        onSale.pop();

        // Update the arrayIndex mapping by setting the value to an empty array
        arrayIndex[_counter][_nftId] = new uint[](0);

        return true;
    }
    else
    {
        return false;
    }
}

    // Helper function to find the index of an NFT in the onSale array
    function findIndexInOnSale(uint _nftId) internal  returns (uint) 
    {
        for ( i = 0; i < onSale.length; i++) 
        {
            if (onSale[i][0] == _nftId) 
            {
                return i;
            }
        }
        revert("NFT not found in onSale array");
    }


    function withdraw() public payable 
    {
        payable(address(this)).transfer(walletBalance[msg.sender]);
    }

    function viewOnSale() public view returns (uint[][] memory) 
    {
        return onSale;
    }
}