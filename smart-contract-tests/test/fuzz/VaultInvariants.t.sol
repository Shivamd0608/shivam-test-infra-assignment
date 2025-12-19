// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../fixtures/VaultFixture.sol";

contract VaultInvariantsTest is VaultFixture {
    function testFuzz_DepositWithdrawInvariant(
        uint96 depositAmount,
        uint96 withdrawAmount
    ) public {
        // Bound deposit to a reasonable range
        depositAmount = uint96(bound(depositAmount, 1e6, 1_000_000e6));
        withdrawAmount = uint96(bound(withdrawAmount, 0, depositAmount));

        // 🔑 IMPORTANT: ensure user has enough USDC
        usdc.mint(user1, depositAmount);

        // Deposit
        _depositAs(user1, depositAmount);

        // Withdraw
        vm.prank(user1);
        vault.withdraw(withdrawAmount, user1);

        uint256 userBalance = vault.balanceOf(user1);
        uint256 totalAssets = vault.totalAssets();

        // Invariant: vault must always cover user balance
        assertGe(
            totalAssets,
            userBalance,
            "invariant violated: totalAssets < user balance"
        );
    }
}
