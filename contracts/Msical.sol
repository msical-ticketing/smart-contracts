// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Upgradeable} from "./Upgradeable.sol";

import {AuthModule} from "./modules/Auth.sol";
import {EventModule} from "./modules/Event.sol";
import {TicketModule} from "./modules/Ticket.sol";

import {IEvent} from "./structs/IEvent.sol";
import {ITicket} from "./structs/ITicket.sol";
import {CreateEventParams} from "./structs/CreateEventParams.sol";
import {CreateTicketParams} from "./structs/CreateTicketParams.sol";

import {IMsical1155} from "./interfaces/IMsical1155.sol";

contract Msical is Upgradeable, AuthModule, EventModule, TicketModule {
    function approveOrganizer(address account) public onlyOwner {
        AuthModule._approveOrganizer(account);
    }

    function createEvent(
        CreateEventParams calldata _createEventParams,
        CreateTicketParams[] calldata _createTicketParams
    ) public {
        if (!isOrganizer(msg.sender)) revert();

        uint256 id = EventModule.create(_createEventParams);

        TicketModule.create(id, _createTicketParams);
    }

    function getAllEvents()
        external
        view
        returns (IEvent[] memory events, ITicket[][] memory tickets)
    {
        events = EventModule._getAllEvents();

        uint256 len = events.length;
        tickets = new ITicket[][](len);

        for (uint256 i = 0; i < len; i++) {
            IEvent memory eventInfo = events[i];
            uint256 eventId = eventInfo.id;

            ITicket[] memory _tickets = TicketModule._getAllTickets(eventId);
            tickets[i] = _tickets;
        }
    }

    function getEventDetails(
        uint256 eventId
    )
        external
        view
        returns (IEvent memory eventInfo, ITicket[] memory tickets)
    {
        eventInfo = EventModule._getEventDetails(eventId);
        tickets = TicketModule._getAllTickets(eventId);
    }

    function buyTicket(
        address collection,
        uint256 eventId,
        uint256 ticketId,
        uint256 amount
    ) external payable {
        // Event is still available for buying
        IEvent memory eventInfo = EventModule._getEventDetails(eventId);
        ITicket memory ticket = TicketModule._getTicket(ticketId);

        // Check if event is still available
        if (block.timestamp > eventInfo.datetime) revert();

        // Check if the msg.value is equal to the expected price
        if (msg.value != ticket.price * amount) revert();

        // Check if the buying amount is available
        if (amount > eventInfo.capacity - eventInfo.soldQuantity) revert();

        if (amount > ticket.totalSupply - ticket.soldQuantity) revert();

        // Check if the msg.sender is not the event creator
        if (msg.sender == eventInfo.creator) revert();

        // * Update event's soldQuantity
        EventModule._onBuying(eventInfo.id, amount);

        TicketModule._onBuyingTicket(ticket.id, amount);

        // Transfer MATIC token to creator
        (bool success, ) = payable(eventInfo.creator).call{value: msg.value}(
            ""
        );
        require(success, "Transfer failed");

        // Mint ticket as NFT to the buyer
        IMsical1155(collection).mint(
            msg.sender,
            ticketId,
            amount,
            ticket.uri,
            ""
        );
    }

    function ver5() external pure returns (string memory) {
        return "ver5";
    }

    function useTicket(
        uint256 eventId,
        uint256 ticketId,
        uint256 amount,
        address creator,
        address collection
    ) external {
        IEvent memory eventInfo = EventModule._getEventDetails(eventId);

        require(creator == eventInfo.creator);

        require(
            IMsical1155(collection).balanceOf(msg.sender, ticketId) >= amount
        );

        IMsical1155(collection).safeTransferFrom(
            msg.sender,
            creator,
            ticketId,
            amount,
            ""
        );
        // Transfer ticket to organizer
    }
}
