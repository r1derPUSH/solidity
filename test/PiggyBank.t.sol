// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {PiggyBank} from "../src/PiggyBank.sol";

/// @title PiggyBankTest
/// @notice Unit tests for the PiggyBank contract
contract PiggyBankTest is Test {
    PiggyBank public piggyBank;

    receive() external payable {}

    /// @notice Deploys a fresh PiggyBank and funds the test contract before each test
    function setUp() public {
        piggyBank = new PiggyBank();
        vm.deal(address(this), 1 ether);
    }

    /// @notice Verifies that deposited ETH is reflected in the contract balance
    function test_Deposit() public {
        piggyBank.deposit{value: 0.5 ether}();
        assertEq(address(piggyBank).balance, 0.5 ether);
    }

    /// @notice Verifies that owner can withdraw part of the deposited ETH
    function test_Withdraw() public {
        piggyBank.deposit{value: 0.5 ether}();
        piggyBank.withdraw(0.2 ether);
        assertEq(address(piggyBank).balance, 0.3 ether);
    }

    /// @notice Verifies that a non-owner withdrawal reverts with the expected message
    function test_WithdrawNotOwner() public {
        piggyBank.deposit{value: 0.5 ether}();
        vm.prank(address(0x1234));
        vm.expectRevert("Not owner");
        piggyBank.withdraw(0.5 ether);
    }
}