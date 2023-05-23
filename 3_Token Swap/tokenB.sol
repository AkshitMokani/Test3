// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 
{
    constructor() ERC20("TokenB", "TB") 
    {
        _mint(msg.sender, 5000 * 10 ** decimals());
    }
}