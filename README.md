# SplitBill Smart Contract DApp

## Project Description

SplitBill is a simple decentralized application (DApp) built on Ethereum that allows users to split shared expenses between multiple people.

Instead of manually calculating debts, the smart contract automatically records who owes money to whom when someone pays for a group.

---

## How it works

1. A user pays for a group (for example: dinner, trip, rent)
2. The user enters:
   - total amount paid
   - list of participants
3. The smart contract:
   - splits the amount equally
   - records debts between users

👉 Example:
If Alice pays 300 ETH for Bob and Charlie:
- Bob owes Alice 100 ETH
- Charlie owes Alice 100 ETH

---

## Smart Contract Features

- Stores debts between users
- Automatically splits payments
- Tracks who owes whom
- Provides view functions to check debts
- No need for users to manually transfer money through the contract

---

## 🛠️ Technologies Used

- Solidity ^0.8.x
- Ethereum blockchain
- MetaMask
- Ethers.js
- HTML / JavaScript frontend

---

## 📂 Project Structure
/contracts → Smart contract (Solidity)
/frontend → HTML + JS DApp
README.md → Project documentation

---

## How to use

1. Deploy smart contract on Ethereum testnet (e.g. Sepolia)
2. Copy contract address into frontend (`contractAddress`)
3. Connect MetaMask wallet
4. Add expenses by entering:
   - amount
   - participants addresses
5. Check debts using "Check Balance"

---

## Important Notes

- Users do NOT pay debts through the contract
- The system only records and displays debt information
