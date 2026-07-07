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

    function test_MintOnlyOwner() public {
    vm.prank(alice);
    vm.expectRevert();
    token.mint(alice, 100 * 10**18);
    }

    function test_TransferInsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(owner, 1 * 10**18);  // скільки у alice? скільки вона намагається відправити?
    }

    function test_ApproveAndTransferFrom() public {
        token.approve(alice, 100 * 10**18);
        vm.prank(alice);
        token.transferFrom(owner, alice, 100 * 10**18);  // скільки переказуємо?
        assertEq(token.balanceOf(alice), 100 * 10**18);
        assertEq(token.balanceOf(owner), 900 * 10**18);
    }

    function testFuzz_Transfer(uint256 amount) public {
        // Foundry кидатиме рандомні значення amount — обмежуємо реальним балансом
        amount = bound(amount, 1, 1000 * 10**18);

        token.transfer(alice, amount);

        assertEq(token.balanceOf(alice), amount);
        assertEq(token.balanceOf(owner), 1000 * 10**18 - amount);
    }

    function testFuzz_TransferNeverOverflow(uint256 amount) public {
        amount = bound(amount, 1, 1000 * 10**18);

        uint256 ownerBefore = token.balanceOf(owner);
        uint256 aliceBefore = token.balanceOf(alice);

        token.transfer(alice, amount);

        // Інваріант: загальна сума завжди постійна
        assertEq(
            token.balanceOf(owner) + token.balanceOf(alice),
            ownerBefore + aliceBefore
        );
    }

    function testFuzz_TransferExceedingBalance(uint256 amount) public {
        // Будь-яка сума більша за баланс мусить ревертитись
        amount = bound(amount, 1000 * 10**18 + 1, type(uint256).max);

        vm.expectRevert();
        token.transfer(alice, amount);
    }
}