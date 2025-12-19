// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../fixtures/VaultFixture.sol";

contract VaultDepositTest is VaultFixture {
    function test_Deposit_IncreasesUserBalance() public {
        uint256 amount = 100e6;

        _depositAs(user1, amount);

        assertEq(vault.balanceOf(user1), amount, "user balance incorrect");
    }

    function test_Deposit_IncreasesTotalAssets() public {
        uint256 amount = 200e6;

        _depositAs(user1, amount);

        assertEq(vault.totalAssets(), amount, "totalAssets incorrect");
    }

    function test_Deposit_MultipleUsers() public {
        _depositAs(user1, 100e6);
        _depositAs(user2, 300e6);

        assertEq(vault.balanceOf(user1), 100e6);
        assertEq(vault.balanceOf(user2), 300e6);
        assertEq(vault.totalAssets(), 400e6);
    }

    function test_Revert_WhenDepositZero() public {
        vm.startPrank(user1);
        usdc.approve(address(vault), 0);

        vm.expectRevert();
        vault.deposit(0, user1);

        vm.stopPrank();
    }
}
