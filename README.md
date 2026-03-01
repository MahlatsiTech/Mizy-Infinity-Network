Mizy Infinity Network

[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue.svg)](https://soliditylang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![BNB Chain](https://img.shields.io/badge/BNB%20Chain-Compatible-yellow.svg)](https://www.bnbchain.org/)
[![Status](https://img.shields.io/badge/Status-Validated%20Prototype-brightgreen.svg)]()

> Dual-Utility Blockchain Infrastructure Protocol for Transparent Energy & Water Management in Emerging Markets

---

Overview

Mizy Infinity Network is a revolutionary blockchain protocol that enables transparent, on-chain accounting for energy and water utilities in emerging markets. Built on BNB Chain for low-cost, high-speed transactions, our protocol addresses the critical infrastructure transparency gap that affects 600 million Africans without reliable electricity access.

The Problem

- 600 million Africans lack reliable electricity access
- 2.5 trillion global infrastructure investment gap
- 40% of water lost to leakages due to opaque systems
- Zero dual-utility blockchain solutions exist in emerging markets

Our Solution: MizyNexus Protocol

1. Sovereign Node Registry - Each household registered with unique blockchain identity
2. Dual-Utility Accounting - Energy (kWh) and water (liters) on a single transparent ledger
3. Event-Based Transparency - Immutable audit trails with real-time verification

---

Smart Contract

MizyNexus.sol

The core smart contract powering the Mizy Infinity Network protocol.

Contract Address (Testnet): `0x2E20e9D6C37fE79ed3e91F75Ec332c51B7a77c35`

Technical Specifications

Property	Value	
Language	Solidity 0.8.20	
License	MIT	
Status	Validated Prototype	
Test Environment	Remix VM (London)	
Target Chain	BNB Smart Chain (BSC) / opBNB	
Transactions Validated	4+ successful	
Event Emission	100% success rate	

Key Features

- Sovereign Node Registration with unique blockchain identities
- Dual-Utility Payment Tracking for energy and water
- Immutable Event Logging for complete transparency
- Treasury Management with configurable fees
- Access Control with owner and authorized deployer roles
- Comprehensive View Functions for data retrieval

---

Quick Start

Prerequisites

- [Remix IDE](https://remix.ethereum.org/) or local Hardhat/Truffle setup
- MetaMask or compatible Web3 wallet
- BNB Chain testnet/mainnet access

Deployment on Remix

1. Open Remix IDE
   
```
   https://remix.ethereum.org/
   ```

2. Create New File
   - Click on "Create New File" in the File Explorer
   - Name it `MizyNexus.sol`
   - Copy and paste the contract code

3. Compile Contract
   - Go to "Solidity Compiler" tab
   - Select compiler version `0.8.20`
   - Click "Compile MizyNexus.sol"

4. Deploy Contract
   - Go to "Deploy & Run Transactions" tab
   - Environment: Select "Injected Provider - MetaMask" for mainnet/testnet
   - Or use "Remix VM (London)" for local testing
   - Click "Deploy"

5. Verify Deployment
   - Check deployed contracts section
   - Copy contract address for verification

Interacting with the Contract

Register a New Node

```javascript
// Call registerNode with node ID and onboarding fee
registerNode("SOWETO_NODE_001")
// Value: 0.01 ETH (or configured onboarding fee)
```

Record Energy Payment

```javascript
// Call payUtility for energy (isWater = false)
payUtility("SOWETO_NODE_001", 100, false)
// Value: Payment amount in ETH
```

Record Water Payment

```javascript
// Call payUtility for water (isWater = true)
payUtility("SOWETO_NODE_001", 200, true)
// Value: Payment amount in ETH
```

Get Node Details

```javascript
// View function - no gas required
getNodeDetails("SOWETO_NODE_001")
```

Get Protocol Statistics

```javascript
// View function - no gas required
getProtocolStats()
```

---

Contract Functions

Write Functions

Function	Description	Access	
`registerNode(string _nodeId)`	Register new sovereign node	Authorized	
`payUtility(string _nodeId, uint256 _amount, bool _isWater)`	Record utility payment	Authorized	
`deactivateNode(string _nodeId)`	Deactivate a node	Authorized	
`reactivateNode(string _nodeId)`	Reactivate a node	Authorized	
`authorizeDeployer(address _deployer)`	Authorize new deployer	Owner	
`deauthorizeDeployer(address _deployer)`	Deauthorize deployer	Owner	
`setTransactionFeePercent(uint256 _newFeePercent)`	Update fee percentage	Owner	
`setNodeOnboardingFee(uint256 _newFee)`	Update onboarding fee	Owner	
`withdrawTreasury(uint256 _amount, address _to)`	Withdraw from treasury	Owner	
`transferOwnership(address _newOwner)`	Transfer contract ownership	Owner	

View Functions

Function	Description	
`getNodeDetails(string _nodeId)`	Get detailed node information	
`getPaymentHistory(string _nodeId)`	Get node's payment history	
`getNodePaymentCount(string _nodeId)`	Get number of payments for node	
`getAllNodes()`	Get all registered node IDs	
`getProtocolStats()`	Get protocol-wide statistics	
`isNodeActive(string _nodeId)`	Check if node is active	
`registry(string _nodeId)`	Direct mapping access to node data	
`authorizedDeployers(address)`	Check if address is authorized	

Events

Event	Description	
`NodeRegistered`	Emitted when new node is registered	
`UtilityPaid`	Emitted when utility payment is recorded	
`NodeDeactivated`	Emitted when node is deactivated	
`NodeReactivated`	Emitted when node is reactivated	
`TreasuryWithdrawal`	Emitted when funds withdrawn from treasury	
`DeployerAuthorized`	Emitted when new deployer authorized	
`DeployerDeauthorized`	Emitted when deployer deauthorized	

---

Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MIZY INFINITY NETWORK                     │
│                  Dual-Utility Protocol                       │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│  Sovereign    │    │   Dual-Utility │    │   Event-Based │
│  Node Registry│    │   Accounting   │    │   Transparency│
└───────────────┘    └───────────────┘    └───────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │   MizyNexus.sol   │
                    │  Smart Contract   │
                    └───────────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │    BNB Chain      │
                    │   Blockchain      │
                    └───────────────────┘
```

---

Market Opportunity

Market Segment	Value	Description	
TAM	2.5 Trillion	Global utility modernization market	
SAM	180 Billion	Emerging markets digitization	
SOM	5 Billion	Africa blockchain adoption (2027)	

Growth Roadmap

Year	Phase	Nodes	
2026 Q1-Q2	Pilot: Soweto	10	
2026 Q3-Q4	Scale: 3 Townships	50	
2027	South Africa Expansion	100	
2028	Pan-African Rollout	1,000	
2030	Multi-Continental	10,000	

---

Revenue Model

Revenue Stream	Description	Rate	
Transaction Fees	Fee on utility payments	1-3%	
Node Onboarding	One-time registration fee	0.01 ETH	
SaaS Dashboard	Municipal analytics subscription	Monthly	
Governance Layer	MIN token participation	Future	

Projected Revenue

Year	Nodes	Revenue	
Year 1	10	8,600	
Year 2	50	49,000	
Year 3	100	110,000	

---

Impact & ESG Metrics

Environmental (Projected at 100 nodes)

- 500 tons/year CO2 reduction
- 1.2 GWh clean energy tracked
- 2 million liters water tracked

Social

- 50+ jobs created for local technicians
- 100 families empowered with transparent utilities
- Zero billing disputes through on-chain records

Governance

- 100% on-chain transparent auditing
- Immutable transaction history
- Verifiable ESG data for impact investors

---

Team

Nthabiseng Mahlatsi - Founder & CEO

- Red Seal Certified Electrical Engineer
- Blockchain & Web3 Developer
- Deep infrastructure expertise
- Based in Soweto, South Africa

> "Infrastructure transparency is not optional — it's essential for economic development. Mizy Infinity Network modernizes public utilities through decentralized transparency, enabling infrastructure-backed digital economies."

---

Competition

Feature	Traditional	MizyNexus	
Transparency	Paper-based, opaque	On-chain, immutable	
Audit Trail	Manual, error-prone	Automated, event-based	
Dual-Utility	Separate systems	Single integrated protocol	
Real-time Data	Delayed (days/weeks)	Instant verification	
Scalability	Limited by bureaucracy	Blockchain-native	

Strategic Barriers to Entry

- Infrastructure Engineering Expertise
- Municipal Integration Complexity
- Community-Rooted Pilot Access
- Regulatory Navigation Capability

---

Contact

Channel	Details	
Email	tholwana28@gmail.com	
Phone	+27 62 821 3248	
GitHub	github.com/MahlatsiTech	
Twitter	@tholwana28	
LinkedIn	Nthabiseng Mahlatsi	
Location	Soweto, South Africa	

Competition Wallet

```
0x2E20e9D6C37fE79ed3e91F75Ec332c51B7a77c35
```

---

License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Acknowledgments

- BNB Chain - For the Smart Builders Challenge opportunity
- Ignyte Challenges - For the competition platform
- Soweto Community - For the inspiration and support

---
