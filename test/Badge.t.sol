// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {StoneBadge} from "../src/StoneBadge.sol";

contract CounterTest is Test {
    StoneBadge public badge;

    function setUp() public {
        badge = new StoneBadge();
    }

    function test_Badge() public {
    }
}
