// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

// ✅ Correct imports (NO spaces, NO vault folder)
import "../../src/TMVault.sol";
import "../../src/mocks/MockUSDC.sol";
import "../../src/mocks/MockProtocol.sol";

contract VaultFixture is Test {
    TMVault internal vault;
    MockUSDC internal usdc;
    MockProtocol internal protocolA;
    MockProtocol internal protocolB;

    address internal manager;
    address internal user1;
    address internal user2;

    function setUp() public virtual {
        manager = makeAddr("manager");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        // Deploy mocks
        usdc = new MockUSDC();
        protocolA = new MockProtocol();
        protocolB = new MockProtocol();

        // Deploy vault
        vault = new TMVault(address(usdc), manager);

        // Seed users with USDC
        usdc.mint(user1, 1_000e6);
        usdc.mint(user2, 1_000e6);
    }

    function _depositAs(address user, uint256 amount) internal {
        vm.startPrank(user);
        usdc.approve(address(vault), amount);
        vault.deposit(amount, user);
        vm.stopPrank();
    }

    function _simulateYield(uint256 bps) internal {
        protocolA.simulateYield(bps);
        protocolB.simulateYield(bps);
    }
}
