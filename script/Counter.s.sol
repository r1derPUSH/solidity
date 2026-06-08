// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

/// @title CounterScript
/// @notice Deployment script for the Counter contract
contract CounterScript is Script {
    /// @notice Empty setup hook required by Foundry script interface
    function setUp() public {}

    /// @notice Deploys a new Counter contract on-chain
    function run() public {
        vm.startBroadcast();

        new Counter();

        vm.stopBroadcast();
    }
}
