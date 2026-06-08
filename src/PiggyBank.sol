// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Контракт повинен мати:

// змінну owner — зберігає адресу власника
// constructor — запускається один раз при деплої, встановлює owner = msg.sender
// deposit() — приймає ETH, payable
// withdraw() — виводить весь ETH на адресу owner, тільки для owner

contract PiggyBank {
    address public owner;

    receive() external payable {}

    mapping (address sender => uint amount) public balances; 

    constructor() {
        owner = msg.sender;
    }

    function deposit () public payable {
        balances[msg.sender] += msg.value;
        // deposit
    }

   function withdraw(uint _amount) public {
        require(msg.sender == owner, "Not owner");
        uint val = balances[msg.sender];
        require(_amount <= val);
        balances[msg.sender] -= _amount;
        (bool ok,) = payable(msg.sender).call{value: _amount}("");
        require(ok, "Transfer failed");
    }

}