// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title PiggyBank
/// @notice A simple ETH savings contract with owner-only withdrawal
/// @dev Uses call instead of transfer for ETH sending
contract PiggyBank {

    /// @notice Address of the contract owner
    address public owner;

    /// @notice Tracks deposited amount per address
    mapping(address sender => uint amount) public balances;

    /// @notice Sets the deployer as owner
    constructor() {
        owner = msg.sender;
    }

    /// @notice Deposit ETH into the piggy bank
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice Withdraw ETH from the piggy bank
    /// @dev Reverts if caller is not owner or amount exceeds balance
    /// @param _amount Amount in wei to withdraw
    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Not owner");
        uint val = balances[msg.sender];
        require(_amount <= val);
        balances[msg.sender] -= _amount;
        (bool ok,) = payable(msg.sender).call{value: _amount}("");
        require(ok, "Transfer failed");
    }
}