// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract OceanToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    constructor(uint256 cap, uint256 reward) ERC20("OceanToken", "OCT") ERC20Capped(cap * (10 ** decimals())) //for implenting maxed cap
    {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals())); //1. Send 70 mill units out of 100 mill
        //supply the owner with some amount of mint
        //70000000 is the initial supply of tokens being minted.
        // In the context of ERC20 tokens, the total supply is often specified in the smallest unit of the token, known as "wei" for Ether, but for ERC20 tokens, it corresponds to the number of smallest divisible units (similar to cents for a dollar).
        // The decimals() function returns the number of decimal places the token uses. For example, if decimals() returns 18 (which is common for many ERC20 tokens), this means that 1 token is represented as 10^18 smallest units.
        // The expression 70000000 * (10 ** decimals()) calculates the total number of smallest units to be minted. If decimals() returns 18, this would mean:

        // 10 ** 18 = 1000000000000000000
        // 70000000 * (10 ** 18) = 70000000 * 1000000000000000000
        // This effectively means 70 million tokens are being minted, taking into account the decimal precision. In summary, 70000000 represents the total number of tokens (in whole units) being minted and assigned to the owner's account.
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override( ERC20, ERC20Capped ) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal{
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0) && ERC20.totalSupply() + blockReward <= cap()) //from != address(0) :- checks that the transfer is not originating from the zero address, which would indicate a minting operation.
        {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value); //calling parent contract of this function in ER20 to ensure that the logic of parent executed along with added functionalities of the derived contract function
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}