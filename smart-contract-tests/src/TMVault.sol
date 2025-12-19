// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TMVault is Ownable {
    IERC20 public immutable asset;

    mapping(address => uint256) public balanceOf;
    uint256 public totalAssets;

    constructor(address _asset, address _manager)  Ownable(_manager){


        asset = IERC20(_asset);
       
    }

    function deposit(uint256 amount, address receiver) external {
        require(amount > 0, "amount = 0");

        asset.transferFrom(msg.sender, address(this), amount);

        balanceOf[receiver] += amount;
        totalAssets += amount;
    }

    function withdraw(uint256 amount, address receiver) external {
        require(balanceOf[msg.sender] >= amount, "insufficient");

        balanceOf[msg.sender] -= amount;
        totalAssets -= amount;

        asset.transfer(receiver, amount);
    }
}
