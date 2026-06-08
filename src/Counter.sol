// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Counter
/// @notice A simple counter contract with increment, decrement and reset
/// @dev Reverts on underflow due to Solidity 0.8+ built-in checks
contract Counter {
    /// @notice Current value of the counter
    uint256 public counter;

    /// @notice Increases the counter by 1
    function increment() external {
        counter += 1;
    }

    /// @notice Decreases the counter by 1
    /// @dev Reverts if counter is already 0
    function decrement() external {
        require(counter > 0, "Counter: already zero");
        counter -= 1;
    }

    /// @notice Resets the counter to 0
    function reset() external {
        counter = 0;
    }
}