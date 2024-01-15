// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./EventMetadata.sol";

contract EventContract is EventMetadata {
    constructor(
        address defaultAdmin,
        address pauser,
        address minter
    ) EventMetadata(defaultAdmin, pauser, minter) {}
}
