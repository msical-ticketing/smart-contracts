// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "../auth/Authorization.sol";
// import "../features/event/Event.sol";

// contract EventManagement is Authorization {
//     /// @custom:storage-location erc7201:openzeppelin.storage.EventManagement
//     struct EventManagementStorage {
//         // TODO: Define what should have in the EventManagementStorage
//         EnumerableMap.AddressToUintMap events;
//     }
//     // keccak256(abi.encode(uint256(keccak256("EventManagementStorage")) - 1)) & ~bytes32(uint256(0xff))
//     bytes32 public constant EventManagementStorageLocation =
//         0x24199fbab51e69894e61b91b5561bd1eae1c4535dfe3dadb088c0caa3284ca00;

//     function _getEventManagementStorage()
//         private
//         pure
//         returns (EventManagementStorage storage $)
//     {
//         assembly {
//             $.slot := EventManagementStorageLocation
//         }
//     }

//     struct EventInfo {
//         address creator;
//         address collection;
//         uint256 capacity;
        
//         mapping(uint256 => uint256) availables;
//         mapping(uint256 => uint256) prices;
        
//     }

//     /**
//      *
//      * Information needed:
//      * 1. Capacity
//      * 2. The number of ticket types
//      * 3. The available number of each ticket type
//      * 4. The price of each ticket type
//      * 5. The tokens that are accepted for payment
//      * 6. When the event takes place?
//      * 7. When the event starts selling?
//      * 8. When the event stops selling?
//      */
//     function createEvent(
//         uint256 totalCapacity,
//         uint256 types,
//         uint256[] calldata availables,
//         uint256[] calldata prices,
//         address[] calldata tokens,
//         uint256[] calldata timestamps
//     ) external {
//         require(isOrganizer(msg.sender), "NOT ORGANIZER");

//         require(types == availables.length);
//         require(types == prices.length);

//         EventContract _event = new EventContract(
//             msg.sender,
//             msg.sender,
//             msg.sender
//         );

//         EventInfo memory info = EventInfo({
//             creator: msg.sender,
//             collection: _event,
//             capacity: totalCapacity,

//         })
//     }
// }
