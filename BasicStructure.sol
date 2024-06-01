// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    constructor(uint256 initialSupply) ERC20("Token", "OCT")
    {
        _mint(msg.sender, initialSupply); //supply the owner with some amount of mint
    }
}