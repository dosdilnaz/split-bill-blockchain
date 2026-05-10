// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SplitBill {

    mapping(address => mapping(address => uint256)) public debts;

    address[] public users;
    mapping(address => bool) public isUser;

    event ExpenseAdded(address indexed payer, uint256 totalAmount);

    function _addUser(address user) internal {
        if (!isUser[user]) {
            isUser[user] = true;
            users.push(user);
        }
    }

    function addExpense(
        uint256 totalAmount,
        address[] memory participants
    ) external {

        require(participants.length > 0, "No participants");
        require(totalAmount > 0, "Amount must be >0");

        uint256 share = totalAmount / participants.length;

        _addUser(msg.sender);

        for (uint i = 0; i < participants.length; i++) {

            address user = participants[i];

            require(user != address(0), "Invalid address");
            require(user != msg.sender, "Payer cannot owe himself");

            _addUser(user);

            debts[user][msg.sender] += share;
        }

        emit ExpenseAdded(msg.sender, totalAmount);
    }

    function getDebt(address user, address creditor)
        external
        view
        returns(uint256)
    {
        return debts[user][creditor];
    }

    function getBalance(address user)
        external
        view
        returns(int256)
    {
        int256 balance = 0;

        for(uint i=0; i<users.length; i++) {

            address other = users[i];

            if(other == user) continue;

            balance += int256(debts[other][user]);
            balance -= int256(debts[user][other]);
        }

        return balance;
    }

    function getAllUsers()
        external
        view
        returns(address[] memory)
    {
        return users;
    }
}
