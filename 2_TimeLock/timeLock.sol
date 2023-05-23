// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract timeLock
{

    address public beneficiary;
    uint public releaseTime;

    mapping (address => uint) public depositAmount;



    constructor(address _beneficiary, uint _releaseTime)
    {
        beneficiary = _beneficiary;
        require(_releaseTime > block.timestamp,"Time must be in future");
        releaseTime = _releaseTime;
    }

    function depositFund(uint _amount) payable public
    {
        require(msg.sender == beneficiary,"Only beneficier can deposit fund");
        require(msg.value > 0 && _amount > 0,"Amount must be greater than zero");

        depositAmount[msg.sender] += _amount;
    }

    function checkStatus() public view returns(bool)
    {
        if(block.timestamp > releaseTime)
        {
            return true;
        }
        else 
        {
            return false;
        }
    }
    
    function withdrawFund() payable public 
    {
        require(block.timestamp > releaseTime,"Your fund is locked");
        require(msg.sender == beneficiary,"Only beneficiary can withdraw fund");
        uint totalBalance = depositAmount[msg.sender];
        depositAmount[msg.sender] =0;
        payable(beneficiary).transfer(totalBalance);
    }
}