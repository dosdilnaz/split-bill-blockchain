// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SplitBill {

    // debtor => creditor => amount
    mapping(address => mapping(address => uint256)) public debts;

    // seznam všech uživatelů
    address[] public users;
    mapping(address => bool) public isUser;

    event ExpenseAdded(address indexed payer, uint256 totalAmount);

    /// @notice uloží usera pokud ještě neexistuje
    function _addUser(address user) internal {
        if (!isUser[user]) {
            isUser[user] = true;
            users.push(user);
        }
    }

    /// @notice payer adds expense paid for multiple people
    function addExpense(address[] memory participants) external payable {
        require(participants.length > 0, "No participants");
        require(msg.value > 0, "No ETH sent");

        uint256 share = msg.value / participants.length;
        require(share > 0, "Too small amount");

        _addUser(msg.sender);

        for (uint256 i = 0; i < participants.length; i++) {
            address user = participants[i];

            require(user != address(0), "Invalid address");
            require(user != msg.sender, "Payer cannot owe himself");

            _addUser(user);

            // user owes msg.sender
            debts[user][msg.sender] += share;
        }

        emit ExpenseAdded(msg.sender, msg.value);
    }

    /// @notice kolik user dluží konkrétnímu creditorovi
    function getDebt(address user, address creditor) external view returns (uint256) {
        return debts[user][creditor];
    }

    /// @notice kolik já dlužím někomu
    function myDebtTo(address creditor) external view returns (uint256) {
        return debts[msg.sender][creditor];
    }

    /// HLAVNÍ FUNKCE — NET BALANCE
    /// + = ostatní dluží tobě
    /// - = ty dlužíš ostatním
    function getBalance(address user) external view returns (int256) {
        int256 balance = 0;

        for (uint256 i = 0; i < users.length; i++) {
            address other = users[i];

            if (other == user) continue;

            // ostatní dluží tobě
            balance += int256(debts[other][user]);

            // ty dlužíš ostatním
            balance -= int256(debts[user][other]);
        }

        return balance;
    }

    /// pomocná funkce (debug)
    function getAllUsers() external view returns (address[] memory) {
        return users;
    }
}
