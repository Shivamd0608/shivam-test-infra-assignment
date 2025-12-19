// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IProtocol
 * @notice Interface for yield-generating protocols used by the vault
 * @dev This is intentionally minimal for testing purposes
 */
interface IProtocol {
    /**
     * @notice Deposit assets into the protocol
     * @param amount Amount of tokens deposited
     */
    function deposit(uint256 amount) external;

    /**
     * @notice Withdraw assets from the protocol
     * @param amount Amount of tokens withdrawn
     */
    function withdraw(uint256 amount) external;

    /**
     * @notice Returns total value managed by the protocol
     */
    function totalValue() external view returns (uint256);
}

