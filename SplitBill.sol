// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SplitBill {

    mapping(address => uint) public balances;

    function addExpense(address[] memory participants) public payable {
        require(participants.length > 0, "No participants");

        uint share = msg.value / participants.length;

        for (uint i = 0; i < participants.length; i++) {
            balances[participants[i]] += share;
        }
    }

    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    function settleDebt() public payable {
        require(balances[msg.sender] >= msg.value, "Not enough debt");
        balances[msg.sender] -= msg.value;
    }
}
