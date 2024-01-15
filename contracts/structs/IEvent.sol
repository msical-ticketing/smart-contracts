// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct IEvent {
    uint256 id;
    address creator;
    uint256 capacity;
    uint256 soldQuantity;
    uint256 datetime;
    string uri;
}
