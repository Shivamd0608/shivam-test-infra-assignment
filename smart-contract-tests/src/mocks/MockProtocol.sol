// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IProtocol.sol";

contract MockProtocol is IProtocol {
    uint256 private _totalValue;

    function deposit(uint256 amount) external override {
        _totalValue += amount;
    }

    function withdraw(uint256 amount) external override {
        require(_totalValue >= amount, "not enough");
        _totalValue -= amount;
    }

    function totalValue() external view override returns (uint256) {
        return _totalValue;
    }

    // helper for tests
    function simulateYield(uint256 bps) external {
        uint256 yield = (_totalValue * bps) / 10_000;
        _totalValue += yield;
    }
}
