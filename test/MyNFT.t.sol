// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT public nft;
    address public owner;
    address public alice;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        nft = new MyNFT();
    }

    function test_MintIncreasesTokenId() public {
        nft.mint(alice);
        assertEq(nft.ownerOf(0), alice);
        assertEq(nft.nextTokenId(), 1);
    }

    function test_MintOnlyOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        nft.mint(alice);
    }

    function test_MultipleMintsUniqueIds() public {
        address bob = makeAddr("bob");
        nft.mint(alice);
        nft.mint(bob);
        assertEq(nft.ownerOf(0), alice);
        assertEq(nft.ownerOf(1), bob);
    }

    function test_OwnerOfNonexistentTokenReverts() public {
        vm.expectRevert();
        nft.ownerOf(999);
    }

    function testFuzz_MintMultiple(uint8 count) public {
        count = uint8(bound(count, 1, 10));
        for (uint256 i = 0; i < count; i++) {
            nft.mint(alice);
        }
        assertEq(nft.nextTokenId(), count);
        assertEq(nft.ownerOf(count - 1), alice);
    }

    function test_CannotMintBeyondMaxSupply() public {
        for (uint256 i = 0; i < 10; i++) {
            nft.mint(alice);
        }
        vm.expectRevert("Max supply reached");
        nft.mint(alice); // 11-й має ревертитись
    }

    function test_TokenURIReturnsCorrectURL() public {
        nft.mint(alice);
        assertEq(nft.tokenURI(0), "https://ipfs.io/ipfs/QmPlaceholder/0");
    }

    function test_PublicMintWithCorrectPrice() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        nft.publicMint{value: 0.01 ether}();
        assertEq(nft.ownerOf(0), alice);
    }

    function test_PublicMintWrongPriceReverts() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        vm.expectRevert("Wrong price");
        nft.publicMint{value: 0.005 ether}();
    }

    function test_WithdrawSendsETHToOwner() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        nft.publicMint{value: 0.01 ether}();

        uint256 balanceBefore = address(this).balance;
        nft.withdraw();
        assertEq(address(this).balance, balanceBefore + 0.01 ether);
    }

    function test_WithdrawFailsIfReceiverRejects() public {
        // мінтимо щоб на контракті був ETH
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        nft.publicMint{value: 0.01 ether}();

        // деплоїмо контракт який відхиляє ETH
        RejectETH rejecter = new RejectETH();

        // передаємо ownership на rejecter
        nft.transferOwnership(address(rejecter));

        // withdraw має зафейлитись бо rejecter не приймає ETH
        vm.prank(address(rejecter));
        vm.expectRevert("Withdraw failed");
        nft.withdraw();
    }

    function test_PublicMintBeyondMaxSupplyReverts() public {
        vm.deal(alice, 1 ether);
        // мінтимо всі 10 через owner (безкоштовно)
        for (uint256 i = 0; i < 10; i++) {
            nft.mint(alice);
        }
        // тепер публічний мінт теж має ревертитись
        vm.prank(alice);
        vm.expectRevert("Max supply reached");
        nft.publicMint{value: 0.01 ether}();
    }

    receive() external payable {}
}

    contract RejectETH {
        // не має receive() або fallback() — відхиляє будь-який ETH
    }