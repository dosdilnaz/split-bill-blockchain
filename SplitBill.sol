// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SplitBill {

    // debtor => creditor => amount
    mapping(address => mapping(address => uint256)) public debts;

    event ExpenseAdded(address indexed payer, uint256 totalAmount);

    /// @notice payer adds expense paid for multiple people
    function addExpense(address[] memory participants) external payable {
        require(participants.length > 0, "No participants");
        require(msg.value > 0, "No ETH sent");

        uint256 share = msg.value / participants.length;
        require(share > 0, "Too small amount");

        for (uint256 i = 0; i < participants.length; i++) {
            address user = participants[i];

            require(user != address(0), "Invalid address");
            require(user != msg.sender, "Payer cannot owe himself");

            // user owes msg.sender
            debts[user][msg.sender] += share;
        }

        emit ExpenseAdded(msg.sender, msg.value);
    }

    /// @notice view how much someone owes you
    function getDebt(address user, address creditor) external view returns (uint256) {
        return debts[user][creditor];
    }

    /// @notice view all debts of caller (simplified helper)
    function myDebtTo(address creditor) external view returns (uint256) {
        return debts[msg.sender][creditor];
    }
}
