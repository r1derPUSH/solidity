// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    // напиши mint функцію сам
    // підказка: public, onlyOwner, викликає _mint

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}