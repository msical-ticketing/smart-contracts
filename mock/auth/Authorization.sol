// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../common/Upgradeable.sol";

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract Authorization is Upgradeable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    error ExistentOrganizer();
    error NotPending();

    /// @custom:storage-location erc7201:openzeppelin.storage.Authorization
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

    function register() external {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        // Revert if msg.sender has already been an organizer
        if ($.organizers.contains(msg.sender)) revert ExistentOrganizer();

        $.isPending.add(msg.sender);

        // TODO: Emit an event
    }

    function isOrganizer(address account) public view returns (bool) {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        return $.organizers.contains(account);
    }

    function approveNewOrganizer(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        if (!$.isPending.contains(account)) revert NotPending();

        $.isPending.remove(account);
        $.organizers.add(account);
    }

    function rejectNewOrganizer(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        if (!$.isPending.contains(account)) revert NotPending();
        $.isPending.remove(account);

        // TODO: Emit an event
    }

    function getAllPending() external view returns (address[] memory) {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        return $.isPending.values();
    }

    function getAllOrganizers() external view returns (address[] memory) {
        AuthorizationStorage storage $ = _getAuthorizationStorage();

        return $.organizers.values();
    }
}
