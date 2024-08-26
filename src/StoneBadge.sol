// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {Attestation} from "@eas/contracts/IEAS.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ScrollBadgeAccessControl} from "@canvas-contracts/src/badge/extensions/ScrollBadgeAccessControl.sol";
import {ScrollBadgeSingleton} from "@canvas-contracts/src/badge/extensions/ScrollBadgeSingleton.sol";
import {ScrollBadgeEligibilityCheck} from "@canvas-contracts/src/badge/extensions/ScrollBadgeEligibilityCheck.sol";
import {ScrollBadgeNoExpiry} from "@canvas-contracts/src/badge/extensions/ScrollBadgeNoExpiry.sol";
import {ScrollBadgeSelfAttest} from "@canvas-contracts/src/badge/extensions/ScrollBadgeSelfAttest.sol";
import {ScrollBadgeNonRevocable} from "@canvas-contracts/src/badge/extensions/ScrollBadgeNonRevocable.sol";
import {ScrollBadge} from "@canvas-contracts/src/badge/ScrollBadge.sol";

contract StoneBadge is
    Ownable,
    ScrollBadgeEligibilityCheck,
    ScrollBadgeSingleton,
    ScrollBadgeNoExpiry,
    ScrollBadgeSelfAttest,
    ScrollBadgeNonRevocable
{
    string public badgeURI;
    mapping(address => bool) public whitelistAddresses;

    constructor() ScrollBadge(0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113) Ownable() {}

    function onIssueBadge(Attestation calldata attestation)
        internal 
        override(ScrollBadge, ScrollBadgeSingleton, ScrollBadgeNoExpiry, ScrollBadgeSelfAttest, ScrollBadgeNonRevocable)
        returns (bool)
    {
        if (!isEligible(attestation.recipient)) {
            revert("Not Eligible");
        }
        return super.onIssueBadge(attestation);
    }

    function onRevokeBadge(Attestation calldata attestation)
        internal
        override(ScrollBadge, ScrollBadgeSingleton, ScrollBadgeNoExpiry, ScrollBadgeSelfAttest)
        returns (bool)
    {
        return super.onRevokeBadge(attestation);
    }

    function isEligible(address recipient) public view override returns (bool) {
        return whitelistAddresses[recipient];
    }

    function badgeTokenURI(bytes32 /*uid*/ ) public view override returns (string memory) {
        return badgeURI;
    }

    function setBaseTokenURI(string memory _newBadgeURI) public onlyOwner {
        badgeURI = _newBadgeURI;
    }

    function addWhitelistAddresses(address[] memory _addresses) public onlyOwner {
        uint256 length = _addresses.length;
        for (uint256 i = 0; i < length;) {
            whitelistAddresses[_addresses[i]] = true;
            unchecked { ++i; }
        }
    }
}
