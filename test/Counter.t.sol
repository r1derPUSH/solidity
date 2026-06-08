// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

/// @title CounterTest
/// @notice Unit tests for the Counter contract
contract CounterTest is Test {
    Counter public counter;

    /// @notice Deploys a fresh Counter before each test
    function setUp() public {
        counter = new Counter();
    }

    /// @notice Verifies that reset sets the counter back to zero
    function test_Reset() public {
        counter.increment();
        counter.increment();
        counter.reset();
        assertEq(counter.counter(), 0);
    }

    /// @notice Verifies that increment increases the counter value
    function test_Increment() public {
        counter.increment();
        counter.decrement();
        counter.increment();
        assertEq(counter.counter(), 1);
    }

    /// @notice Verifies that decrement decreases the counter value
    function test_Decrement() public {
        counter.increment();
        counter.decrement();
        counter.increment();
        counter.decrement();
        assertEq(counter.counter(), 0);
    }

    /// @notice Verifies that decrementing below zero reverts
    function test_DecrementUnderflow() public {
        vm.expectRevert();
        counter.decrement();
    }
}