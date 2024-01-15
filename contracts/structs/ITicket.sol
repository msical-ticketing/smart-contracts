// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct ITicket {
    uint256 id;
    uint256 price;
    uint256 totalSupply;
    uint256 soldQuantity;
    string uri;
}
