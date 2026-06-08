// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

   function test_Reset() public {
        counter.increment();
        counter.increment();
        counter.reset();
        assertEq(counter.counter(), 0);
    }

    function test_Increment() public {
        counter.increment();
        counter.decrement();
        counter.increment();
        assertEq(counter.counter(), 1);
    }

    function test_Decrement() public {
        counter.increment();
        counter.decrement();
        counter.increment();
        counter.decrement();
        assertEq(counter.counter(), 0);
    }

    function test_DecrementUnderflow() public {
        vm.expectRevert();
        counter.decrement();
    }
}