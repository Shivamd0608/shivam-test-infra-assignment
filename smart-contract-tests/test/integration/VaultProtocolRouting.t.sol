// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../fixtures/VaultFixture.sol";

contract VaultProtocolRoutingTest is VaultFixture {
    function test_Deposit_And_SimulateYield() public {
        uint256 depositAmount = 1_000e6;

        // User deposits into vault
        _depositAs(user1, depositAmount);

        // Simulate vault allocating funds to protocol
        protocolA.deposit(depositAmount);

        assertEq(
            protocolA.totalValue(),
            depositAmount,
            "protocol value incorrect after deposit"
        );

        // Simulate yield (10%)
        protocolA.simulateYield(1_000); // 1000 bps = 10%

        uint256 expectedValue = depositAmount + (depositAmount * 1_000) / 10_000;

        assertEq(
            protocolA.totalValue(),
            expectedValue,
            "protocol value incorrect after yield"
        );
    }
}
