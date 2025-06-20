# 🚀 VestedLaunch

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/YOUR_GITHUB_USERNAME/VestedLaunch/ci.yml)](https://github.com/YOUR_GITHUB_USERNAME/VestedLaunch/actions)
[![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-lightgrey.svg)](https://soliditylang.org/)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](#)

> **VestedLaunch** is a secure, decentralized smart contract protocol for managing token launches with vesting schedules. Ideal for Web3 projects seeking to ensure fair distribution, prevent dumps, and enforce lockups.

---

## 📜 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Smart Contract Interface](#smart-contract-interface)
- [Testing](#testing)
- [Deployment](#deployment)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

- 🔒 **Secure Vesting Contracts** — Time-locked token allocations per user.
- 🧠 **Customizable Vesting Logic** — Cliff, linear, or step-based vesting supported.
- ⚙️ **Admin Controls** — Project creators can pause, revoke, or audit vesting entries.
- 🔁 **Automated Claiming** — Users can claim vested tokens via the UI or directly on-chain.
- ⛓️ **ERC20-Compliant** — Easily integrable with standard token contracts.
- 📊 **Event Logging** — All major actions emit events for analytics/dApp integration.

---

## 🏗️ Architecture

```mermaid
graph TD
    A[Project Creator] -->|Creates| B[Vesting Schedule]
    B --> C[Smart Contract]
    C --> D[Token Lockup]
    D -->|Time Elapses| E[Claimable Balance]
    E --> F[User Claims Token]
🔧 Installation
bash
git clone https://github.com/YOUR_GITHUB_USERNAME/VestedLaunch.git
cd VestedLaunch
npm install
Requires: Node.js ≥ 18, Hardhat, Ethers.js, Solidity ≥ 0.8.20

🚀 Usage
Compile Contracts
bash
npx hardhat compile
Deploy (Local/Testnet)
bash
npx hardhat run scripts/deploy.ts --network goerli
Interact
Use the built-in Hardhat tasks or a front-end interface:

bash
npx hardhat create-vesting --beneficiary <address> --amount <value> --start <timestamp> --cliff <seconds> --duration <seconds>
📘 Smart Contract Interface
VestedLaunch.sol
solidity
function createVestingSchedule(
    address beneficiary,
    uint256 start,
    uint256 cliff,
    uint256 duration,
    uint256 amount
) external;

function release(address beneficiary) external;

function revoke(address beneficiary) external;
Events
solidity
event VestingCreated(address indexed beneficiary, uint256 amount);
event TokensReleased(address indexed beneficiary, uint256 amount);
event VestingRevoked(address indexed beneficiary);
🧪 Testing
bash
npx hardhat test
Includes full unit test coverage with chai and ethers.

🧾 Deployment
scripts/deploy.ts: Deploy the contract with vesting parameters.

scripts/verify.ts: Verify on Etherscan post-deployment.

Add .env for environment variables:

bash
PRIVATE_KEY=your_wallet_private_key
INFURA_API_KEY=your_infura_key
🔐 Security
✅ Follows Solidity best practices (checks-effects-interactions pattern).

🧪 100% unit test coverage (add fuzz and invariant tests for production).

🔍 Recommend formal audit for production deployment.
