// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public token;
    address public owner;
    address public alice;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        token = new MyToken(1000 * 10**18);
    }

    function test_InitialSupply() public view {
        assertEq(token.totalSupply(), 1000 * 10**18);
    }

    function test_OwnerBalance() public view {
        assertEq(token.balanceOf(owner), 1000 * 10**18);
    }

    function test_Transfer() public {
        token.transfer(alice, 100 * 10**18);
        assertEq(token.balanceOf(alice), 100 * 10**18);
        assertEq(token.balanceOf(owner), 900 * 10**18);
    }
}