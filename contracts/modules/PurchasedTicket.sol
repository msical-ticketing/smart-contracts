// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract PurchasedTicket {
    /// @custom:storage-location erc7201:openzeppelin.storage.PurchasedTicket
    struct PurchasedTicketStorage {
        mapping(address account => mapping(uint256 eventId => mapping(uint256 ticketId => uint256))) balances;
    }

    // function
}
