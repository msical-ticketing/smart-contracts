// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMsical1155 {
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        string calldata _uri,
        bytes calldata data
    ) external;

    function balanceOf(
        address account,
        uint256 id
    ) external pure returns (uint256);

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;
}
