# Hydra Hub - Fund 14 Proposal

## Project Overview

**Hydra Hub** is a platform designed to simplify access to Hydra nodes for developers and end-users. This repository contains documentation, milestone reports, and evidence of completion for our Project Catalyst Fund 14 proposal.

The core objective is to build a scalable system consisting of a **Consumer Portal** for managing access requests and an **Admin Dashboard** for node allocation and monitoring.

## Repository Structure

- `milestone-1.md`: Completion report and evidence for Milestone 1.
- `milestone-2.md`: Completion report and evidence for Milestone 2.
- `milestone-3.md`: Completion report and evidence for Milestone 3.
- `ms1/`: Milestone 1 supporting documents (QA reports, screenshots, user manual).
- `ms2/`: Milestone 2 supporting documents (evidence report, QA reports, screenshots).
- `ms3/`: Milestone 3 supporting documents (payment-subscription smart contract, QA reports).

## Milestone 1: Core System Development

Our first milestone focuses on establishing the core infrastructure and user interfaces.

### Key Components

1.  **Consumer Portal**:
    - User registration and secure authentication.
    - Profile management.
    - Submission interface for Hydra node access requests.
    - Responsive design for Desktop and Mobile.

2.  **Admin Dashboard**:
    - Review and approval workflows for user requests.
    - Real-time monitoring of node allocation status.
    - User management and activity logging.

### Acceptance Criteria

- **Role-Based Access Control (RBAC)**: Strict separation between Consumer and Admin roles.
- **Node Allocation Control**: Admins can allocate or revoke node usage rights directly.
- **System Integration**: Full backend integration with PostgreSQL database (managing users, requests, allocations).
- **Compatibility**: Validated on Chrome v120+ and Safari v17+, supporting responsive layouts (1920x1080 and 375x812).

## Milestone 2: Single Provider Node Deployment & Integration

The second milestone integrates a Hydra provider node into the platform and validates it through developer testing.

### Key Deliverables

1.  **Provider Node Integration**:
    - Hydra provider node registered and managed via Admin Dashboard.
    - Node allocation to developers through the platform.

2.  **Runtime Monitoring & Alerting**:
    - Real-time metrics display (CPU, RAM, network latency, transaction activity).
    - Alert system for node health deterioration (unreachable, CPU/RAM threshold).

3.  **Developer Testing**:
    - 5 external developers performed full Hydra operation cycles.
    - Operations tested: Head Open, UTXO Commit, Transaction, Fanout.

4.  **Uptime Validation**:
    - Node maintained 24-hour continuous operation.

### Acceptance Criteria

- Provider node registered and visible in Admin Dashboard.
- Runtime monitoring and alert configuration functional.
- All 5 developers successfully completed Hydra operations.
- Developer feedback collected via GitHub issue.

## Milestone 3: On-chain Payment Subscription

The third milestone implements an on-chain payment system for subscription upgrades using Aiken smart contracts.

### Key Deliverables

1.  **Smart Contract Development**:
    - Aiken `timed_deposit` validator for payment lock mechanism.
    - 24-hour dispute period for refund protection.
    - Deployed to Cardano Pre-Production Testnet.

2.  **Payment Operations**:
    - **Buy (Lock)**: User locks ADA for subscription upgrade.
    - **Refund**: Admin can refund within dispute period.
    - **Claim**: Admin claims funds after dispute period.

3.  **Platform Integration**:
    - Payment status reflection in user account upgrades.
    - Admin dashboard for payment management.

4.  **Smart Contract Details**:
    - **Script Hash**: `41631ceb642272fbf20a2de0563b472f0d83cf78ca5c9b5708c94b9f`
    - **Plutus Version**: V3
    - **Compiler**: Aiken v1.1.21

### Acceptance Criteria

- Smart contract deployed to Cardano preprod testnet.
- Successful on-chain transactions: Buy, Refund, Claim.
- Time validation enforces 24-hour dispute period.
- Platform integration reflects payment status in account upgrades.
- All test cases passed with 100% success rate.

### Documentation

- [Milestone 3 Evidence Report](./milestone-3.md)
- [QA Report (EN)](./ms3/qa-report/readme.md) | [(VI)](./ms3/qa-report/readme-vi.md)
- [Smart Contract Source](./ms3/payment-subscription/validators/timed_deposit.ak)
- [Compiled Blueprint](./ms3/payment-subscription/plutus.json)

---

_Submitted for Cardano Project Catalyst Fund 14_
