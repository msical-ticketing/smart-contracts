// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

abstract contract Authorization {
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @custom:storage-location erc7201:openzeppelin.storage.AuthorizationStorage
    struct AuthorizationStorage {
        EnumerableSet.AddressSet organizers;
        EnumerableSet.AddressSet isPending;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Authorization")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant AuthorizationStorageLocation =
        0x88ba75e972da1d3a03c4eb10c881213116408a61bfed6973df06cd535ffa6200;

    function _getAuthorizationStorage()
        private
        pure
        returns (AuthorizationStorage storage $)
    {
        assembly {
            $.slot := AuthorizationStorageLocation
        }
    }
}
