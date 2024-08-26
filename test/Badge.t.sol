// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StoneBadge} from "../src/StoneBadge.sol";
import {Attestation, IEAS, AttestationRequest, AttestationRequestData} from "@eas/contracts/IEAS.sol";

contract CounterTest is Test {
    StoneBadge public badge;
    IEAS public eas = IEAS(0xC47300428b6AD2c7D03BB76D05A176058b47E6B0);
    bytes32 schema = 0xd57de4f41c3d3cc855eadef68f98c0d4edd22d57161d96b7c06d2f4336cc3b49;

    function setUp() public {
        uint256 scroll = vm.createFork("https://rpc.scroll.io");
        vm.selectFork(scroll);
        badge = new StoneBadge();
    }

    function test_Badge() public {
        address[] memory ads = new address[](1);
        ads[0] = address(1);

        badge.addWhitelistAddresses(ads);
        vm.startPrank(address(1));
        
        bytes memory payload = abi.encode("StakeStone");
        bytes memory attestationData = abi.encode(badge, payload);

        AttestationRequestData memory _attData = AttestationRequestData({
            recipient: address(1),
            expirationTime: 0,
            revocable: false,
            refUID: 0,
            data: attestationData,
            value: 0
        });

        AttestationRequest memory _req = AttestationRequest({schema: schema, data: _attData});

        eas.attest(_req);
    }
}
