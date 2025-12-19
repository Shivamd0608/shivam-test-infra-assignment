// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../fixtures/VaultFixture.sol";

contract VaultWithdrawTest is VaultFixture {
    function test_Withdraw_ReducesUserBalance() public {
        uint256 amount = 200e6;

        _depositAs(user1, amount);

        vm.startPrank(user1);
        vault.withdraw(100e6, user1);
        vm.stopPrank();

        assertEq(vault.balanceOf(user1), 100e6);
    }

    function test_Withdraw_ReducesTotalAssets() public {
        _depositAs(user1, 300e6);

        vm.prank(user1);
        vault.withdraw(100e6, user1);

        assertEq(vault.totalAssets(), 200e6);
    }

    function test_Withdraw_TransfersUSDC() public {
        _depositAs(user1, 150e6);

        uint256 balanceBefore = usdc.balanceOf(user1);

        vm.prank(user1);
        vault.withdraw(50e6, user1);

        uint256 balanceAfter = usdc.balanceOf(user1);

        assertEq(balanceAfter - balanceBefore, 50e6);
    }

    function test_Revert_WhenWithdrawingMoreThanBalance() public {
        _depositAs(user1, 100e6);

        vm.startPrank(user1);
        vm.expectRevert();
        vault.withdraw(200e6, user1);
        vm.stopPrank();
    }
}
