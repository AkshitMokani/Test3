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

    constructor(address _tokenA, address _tokenB, address _tokenOwner)
    {
        tokenA = _tokenA;
        tokenB = _tokenB;
        tokenOwner = _tokenOwner;
    }

    function addLiquidity(uint _amountTokenA_B) public
    {
        require(IERC20(tokenA).balanceOf(msg.sender) >= _amountTokenA_B, "Not enough TokenA");
        require(IERC20(tokenB).balanceOf(msg.sender) >= _amountTokenA_B, "Not enough TokenB");

        IERC20(tokenA).approve(address(this),_amountTokenA_B);
        IERC20(tokenB).approve(address(this),_amountTokenA_B);
        IERC20(tokenA).transferFrom(msg.sender, address(this), _amountTokenA_B);
        IERC20(tokenB).transferFrom(msg.sender, address(this), _amountTokenA_B);
    }

    function checkPool() public view returns(uint A, uint B)
    {
        return (IERC20(tokenA).balanceOf(address(this)), IERC20(tokenB).balanceOf(address(this)) );
    }

    function swapRate() public returns(uint, uint)
    {
        uint tA = IERC20(tokenA).balanceOf(address(this)); 
        uint tB = IERC20(tokenB).balanceOf(address(this));
        totalA = tA * 10 ** 18 ;
        totalB = tB * 10 ** 18 ;

        tokenAPrice =  tA / totalB;
        tokenBPrice =  tB / totalA;

        return(tokenAPrice,tokenBPrice);
    }

    function AtoB(uint _amount) public returns(uint amountOfA, uint totalAmount, uint amountOfB)
    {
        require(IERC20(tokenA).balanceOf(msg.sender) >= _amount, "you haven't enough balance of TokenA ");
        
        uint amountA = _amount * tokenAPrice;
        uint swapB = amountA / tokenBPrice;
        require(IERC20(tokenB).balanceOf(address(this)) >= swapB, "There is not enough Liquidity");

        IERC20(tokenA).transferFrom(msg.sender, address(this), _amount);
        IERC20(tokenB).transferFrom(address(this),msg.sender,swapB);

        return(_amount,amountA,swapB );   
    }

    function BtoA(uint _amount) public returns(uint amountOfB, uint totalAmount, uint amountOfA)
    {
        require(IERC20(tokenB).balanceOf(msg.sender) >= _amount, "You haven't enough balance of TokenB ");

        uint amountB = _amount * tokenBPrice;
        uint swapA = amountB / tokenAPrice;
        require(IERC20(tokenA).balanceOf(address(this)) >= swapA, "There is not enough Liquidity");

        IERC20(tokenB).transferFrom(msg.sender, address(this), _amount);
        IERC20(tokenA).transferFrom(address(this), msg.sender, swapA);

        return(_amount,amountB,swapA);  
    }
}










//     function fetchPrice() public 
//     {
//         swapRate();
//         emit Price(tokenAPrice, tokenBPrice);
//     }


    // function AtoB(uint _QTY) public returns(uint B)
    // {       
    //     uint weiQTY = _QTY;   
    //     require(IERC20(tokenA).balanceOf(msg.sender) >= weiQTY,"Not enough balance");

    //     uint amountA = weiQTY * tokenAPrice; 
    //     uint swapB = amountA / tokenBPrice;

    //     //IERC20(tokenA).approve(tokenOwner,weiQTY);
    //     //IERC20(tokenA).transferFrom(msg.sender,tokenOwner,weiQTY);
    //     IERC20(tokenA).transfer(msg.sender,weiQTY);

    //     //IERC20(tokenB).approve(msg.sender,swapB);
    //     IERC20(tokenB).transferFrom(tokenOwner,msg.sender,swapB);

    //     return swapB;
    // }

//     function BtoA(uint _QTY) public returns(uint A)
//     {
//         swapRate();
//         uint weiQTY = _QTY * 10 ** 18;
//         require(IERC20(tokenB).balanceOf(msg.sender) >= weiQTY);
//         //require(_QTY % 4 == 0,"please provide proper value");

//         uint amountB = weiQTY * tokenBPrice;
//         amountB = amountB * 10 ** 18;
//         uint swapA = amountB / tokenAPrice;

//         IERC20(tokenB).approve(address(this),weiQTY);

//         IERC20(tokenB).transferFrom(msg.sender,tokenOwner,weiQTY);
//         IERC20(tokenA).transferFrom(tokenOwner,msg.sender,swapA);
//         return swapA;
//     }

