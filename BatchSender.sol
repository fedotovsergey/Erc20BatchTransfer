// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BatchSender {
    address payable public immutable owner;

    constructor() {
        owner = payable(msg.sender);  // Set the contract deployer as the owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function batchTransfer(
        IERC20 token,
        address[] calldata receivers,
        uint256[] calldata amounts
    ) external onlyOwner {
        require(receivers.length == amounts.length, "Mismatched inputs");
        for (uint256 i = 0; i < receivers.length; i++) {
            address(token).call(abi.encodeCall(token.transferFrom, (owner, receivers[i], amounts[i])));
        }
    }
}
