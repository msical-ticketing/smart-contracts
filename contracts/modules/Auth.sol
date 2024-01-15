// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

struct Organizer {
    uint256 status;
    uint256 nonce;
    address account;
    string name;
}

abstract contract AuthModule {
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @custom:storage-location erc7201:openzeppelin.storage.Auth
    struct AuthStorage {
        EnumerableSet.AddressSet organizers;
        mapping(address account => Organizer) organizerInfos;
    }

    bytes32 private constant AuthStorageLocation =
        keccak256(
            abi.encode(uint256(keccak256("openzeppelin.storage.Auth")) - 1)
        ) & ~bytes32(uint256(0xff));

    function _getAuthStorage() private pure returns (AuthStorage storage $) {
        bytes32 location = AuthStorageLocation;

        assembly {
            $.slot := location
        }
    }

    enum OrganizerStatus {
        UNREGISTERED,
        REGISTERED,
        APPROVED
    }

    function register(string calldata name) external {
        AuthStorage storage $ = _getAuthStorage();

        if ($.organizers.contains(msg.sender)) revert();

        Organizer memory organizer = Organizer(
            uint256(OrganizerStatus.REGISTERED),
            0,
            msg.sender,
            name
        );

        $.organizers.add(msg.sender);
        $.organizerInfos[msg.sender] = organizer;
    }

    function getOrganizerDetail(
        address account
    ) external view returns (Organizer memory) {
        AuthStorage storage $ = _getAuthStorage();

        return $.organizerInfos[account];
    }

    function getAllOrganizerDetails()
        external
        view
        returns (Organizer[] memory result)
    {
        AuthStorage storage $ = _getAuthStorage();

        address[] memory keys = $.organizers.values();
        uint256 len = keys.length;
        result = new Organizer[](len);

        for (uint256 i = 0; i < len; i++) {
            result[i] = $.organizerInfos[keys[i]];
        }
    }

    function getAllOrganizers() public view returns (address[] memory) {
        AuthStorage storage $ = _getAuthStorage();

        return $.organizers.values();
    }

    function isOrganizer(address account) public view returns (bool) {
        AuthStorage storage $ = _getAuthStorage();

        if (!$.organizers.contains(account)) return false;

        if (
            $.organizerInfos[account].status !=
            uint256(OrganizerStatus.APPROVED)
        ) return false;

        return true;
    }

    function _approveOrganizer(address account) internal virtual {
        AuthStorage storage $ = _getAuthStorage();

        if (!$.organizers.contains(account)) revert();

        if (
            $.organizerInfos[account].status !=
            uint256(OrganizerStatus.REGISTERED)
        ) revert();

        $.organizerInfos[account].status = uint256(OrganizerStatus.APPROVED);
    }
}
