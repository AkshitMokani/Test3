// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract DEX
{
    address public tokenA;
    address public tokenB;
    address tokenOwner;

    uint public totalA;
    uint public totalB;

    uint public tokenAPrice;
    uint public tokenBPrice;

    event Price(uint tokenA_Price, uint tokenB);

    constructor(address _tokenA, address _tokenB, address _tokenOwner)
    {
        tokenA = _tokenA;
        tokenB = _tokenB;
        tokenOwner = _tokenOwner;
    }

    function swapRate() private returns(uint, uint)
    {
        totalA = IERC20(tokenA).balanceOf(tokenOwner);
        totalB = IERC20(tokenB).balanceOf(tokenOwner);

        tokenAPrice =  (totalA * 10 ** 9) / totalB ;
        tokenBPrice =  (totalB * 10 ** 9) / totalA ;

        //return(totalA,totalB);
        return(tokenAPrice,tokenBPrice);
    }

    function fetchPrice() public 
    {
        swapRate();
        emit Price(tokenAPrice, tokenBPrice);
    }

// 1 A = 20rs
// 1 B = 5rs;

    function AtoB(uint _QTY) public  returns(uint B)
    {
        // swapRate();       
        require(IERC20(tokenA).balanceOf(msg.sender) >= _QTY);

        uint amountA = _QTY * tokenAPrice; 
        amountA = amountA * 10 ** 9;
        uint swapB = amountA / tokenBPrice;

        IERC20(tokenA).approve(address(this),_QTY);
        
        IERC20(tokenA).transferFrom(msg.sender,tokenOwner,_QTY);
        IERC20(tokenB).transferFrom(tokenOwner,msg.sender,swapB);

        return swapB;
    }

    function BtoA(uint _QTY) public returns(uint A)
    {
        require(IERC20(tokenB).balanceOf(msg.sender) >= _QTY);
        //require(_QTY % 4 == 0,"please provide proper value");

        uint amountB = _QTY * tokenBPrice;
        amountB = amountB * 10 ** 9;
        uint swapA = amountB / tokenAPrice;

        IERC20(tokenB).approve(address(this),_QTY);

        IERC20(tokenB).transferFrom(msg.sender,tokenOwner,_QTY);
        IERC20(tokenA).transferFrom(tokenOwner,msg.sender,swapA);
        return swapA;
    }

}