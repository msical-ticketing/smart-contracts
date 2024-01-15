// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITicket} from "../structs/ITicket.sol";
import {CreateTicketParams} from "../structs/CreateTicketParams.sol";

abstract contract TicketModule {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ticket
    struct TicketStorage {
        mapping(uint256 eventId => uint256[]) ticketIds;
        mapping(uint256 ticketId => ITicket) ticketInfos;
        uint256 counter;
    }

    bytes32 private constant TicketStorageLocation =
        keccak256(
            abi.encode(uint256(keccak256("openzeppelin.storage.Ticket")) - 1)
        ) & ~bytes32(uint256(0xff));

    function _getTicketStorage()
        private
        pure
        returns (TicketStorage storage $)
    {
        bytes32 location = TicketStorageLocation;

        assembly {
            $.slot := location
        }
    }

    function create(
        uint256 eventId,
        CreateTicketParams[] calldata _ticketParams
    ) internal {
        TicketStorage storage $ = _getTicketStorage();

        uint256 len = _ticketParams.length;

        for (uint256 i = 0; i < len; i++) {
            CreateTicketParams memory _params = _ticketParams[i];

            uint256 ticketId = ++$.counter;

            // Add the ticket id to the current event
            $.ticketIds[eventId].push(ticketId);

            // Create new ITicket instance
            ITicket memory newTicket = ITicket({
                id: ticketId,
                price: _params.price,
                totalSupply: _params.totalSupply,
                soldQuantity: 0,
                uri: _params.uri
            });

            // Save the ticket info
            $.ticketInfos[ticketId] = newTicket;
        }
    }

    function _getAllTickets(
        uint256 eventId
    ) internal view returns (ITicket[] memory result) {
        TicketStorage storage $ = _getTicketStorage();

        uint256[] memory ticketIds = $.ticketIds[eventId];
        uint256 len = ticketIds.length;

        result = new ITicket[](len);

        for (uint256 i = 0; i < len; i++) {
            uint256 ticketId = ticketIds[i];
            ITicket memory ticketInfo = $.ticketInfos[ticketId];
            result[i] = ticketInfo;
        }
    }

    function _getTicket(
        uint256 ticketId
    ) internal view returns (ITicket memory result) {
        TicketStorage storage $ = _getTicketStorage();

        return $.ticketInfos[ticketId];
    }

    function _getAllTicketIds(
        uint256 eventId
    ) internal view returns (uint256[] memory) {
        TicketStorage storage $ = _getTicketStorage();

        return $.ticketIds[eventId];
    }

    function _onBuyingTicket(uint256 ticketId, uint256 amount) internal {
        TicketStorage storage $ = _getTicketStorage();

        $.ticketInfos[ticketId].soldQuantity += amount;
    }
}
