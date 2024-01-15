// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {IEvent} from "../structs/IEvent.sol";
import {CreateEventParams} from "../structs/CreateEventParams.sol";

abstract contract EventModule {
    using EnumerableSet for EnumerableSet.UintSet;

    /// @custom:storage-location erc7201:openzeppelin.storage.Event
    struct EventStorage {
        EnumerableSet.UintSet eventIds;
        mapping(uint256 eventId => IEvent) events;
        uint256 counter;
    }

    bytes32 private constant EventStorageLocation =
        keccak256(
            abi.encode(uint256(keccak256("openzeppelin.storage.Event")) - 1)
        ) & ~bytes32(uint256(0xff));

    function _getEventStorage() private pure returns (EventStorage storage $) {
        bytes32 location = EventStorageLocation;

        assembly {
            $.slot := location
        }
    }

    function create(
        CreateEventParams memory _params
    ) internal virtual returns (uint256 eventId) {
        EventStorage storage $ = _getEventStorage();

        // Increate counter
        eventId = ++$.counter;

        // Add new event ID into the set
        $.eventIds.add(eventId);

        // Create a new IEvent instance
        IEvent memory newEvent = IEvent({
            id: eventId,
            creator: msg.sender,
            capacity: _params.capacity,
            soldQuantity: 0,
            datetime: _params.datetime,
            uri: _params.uri
        });

        // Store the newEvent into the mapping
        $.events[eventId] = newEvent;
    }

    function _getAllEvents() internal view returns (IEvent[] memory result) {
        EventStorage storage $ = _getEventStorage();

        // Get all event ids
        uint256[] memory eventIds = $.eventIds.values();
        uint256 len = eventIds.length;
        result = new IEvent[](len);

        for (uint256 i = 0; i < len; i++) {
            uint256 id = eventIds[i];
            result[i] = $.events[id];
        }
    }

    function _getEventDetails(
        uint256 id
    ) internal view returns (IEvent memory) {
        EventStorage storage $ = _getEventStorage();

        return $.events[id];
    }

    function _onBuying(uint256 eventId, uint256 amount) internal {
        EventStorage storage $ = _getEventStorage();

        $.events[eventId].soldQuantity += amount;
    }
}
