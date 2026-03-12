# Server Deployment & Configuration Report

**Project:** Hydra Hub (Fund14)  
**Milestone ID:** 1400060  
**Phase:** Milestone 2 - Single Provider Node Deployment & Integration  
**Report Date:** 2026-03-12  
**Reporter:** Hydra Hub Development Team  

---

## 1. Executive Summary

This document provides evidence of the server deployment and configuration for the Hydra provider node integrated into the Hydra Hub platform. The node has been deployed, configured, and maintained stable operation throughout the required minimum **24-hour continuous testing period**.

**Overall Result:** ✅ **PASSED**

---

## 2. Architecture Overview

Hydra Hub does not directly operate Hydra infrastructure nodes. Instead, it allows infrastructure providers to register Hydra nodes and provide them to developers through a managed access layer.

The system architecture consists of three main components:

| Component | Description |
|-----------|-------------|
| **Provider Layer** | Hydra nodes operated by infrastructure providers, connected to Cardano Layer 1 |
| **Hydra Hub Platform** | Node registration, access allocation, monitoring, consumer authentication |
| **Consumer Layer** | Developers connect their dApps through Hydra Hub |

### System Flow

```
[Cardano L1] ← → [Hydra Node (Provider)] ← → [Hydra Hub Platform] ← → [Developer dApps]
```

---

## 3. Server Configuration

### 3.1. Node Infrastructure

| Parameter | Details |
|-----------|---------|
| Node Type | Hydra Provider Node |
| Network | Cardano Preview Testnet |
| Hydra Node Version | Compatible with current Cardano node |
| Deployment Method | Docker containerized deployment |
| Monitoring | Integrated with Hydra Hub Admin Dashboard |

### 3.2. Services Running

| Service | Status |
|---------|--------|
| `cardano-node` | ✅ Running |
| `hydra-node` | ✅ Running |
| Hydra Hub API Gateway | ✅ Running |
| Monitoring Agent | ✅ Running |

---

## 4. 24-Hour Continuous Uptime Evidence

The node maintained operation throughout the required minimum 24-hour continuous testing period without any interruptions.

### 4.1. Node Terminal Running

![Node Terminal Running](../screenshots/node-running/node-terminal-running.png.png)

### 4.2. Uptime Evidence - Timestamp 18:21 (2026-03-11)

![Node Running Evidence 1 - 2026-03-11 18:21](../screenshots/node-running/Screenshot%20from%202026-03-11%2018-21-57.png)

### 4.3. Uptime Evidence - Timestamp 18:22 (2026-03-11)

![Node Running Evidence 2 - 2026-03-11 18:22](../screenshots/node-running/Screenshot%20from%202026-03-11%2018-22-30.png)

### 4.4. Hydra Node State Log

The Hydra node state log file ([`state`](../state)) provides a complete, machine-readable record of all node events during the testing period.

**Log Summary:**

| Parameter | Value |
|-----------|-------|
| Log file | [`state`](../state) (JSON Lines format) |
| Time range | `2026-03-10T11:37:33Z` → `2026-03-12T08:25:29Z` |
| Duration | ~44 hours 48 minutes |
| Total events | 8,148 |
| First event | `NetworkConnected` — Node connected to network |
| Peer connected | `hexcore-hydra-node-84:11006` |

**Event Distribution:**

| Event Type | Count | Description |
|-----------|-------|-------------|
| `TickObserved` | 5,802 | Chain slot ticks observed (continuous L1 sync) |
| `DepositExpired` | 2,252 | Deposit expiry events processed |
| `ChainRolledBack` | 54 | Chain rollback events handled |
| `IgnoredHeadInitializing` | 21 | Head initialization filtering |
| `PartySignedSnapshot` | 3 | Snapshot signing events |
| `DepositRecorded` | 2 | Deposit recording events |
| `CommittedUTxO` | 2 | UTxO commit confirmations |
| `HeadInitialized` | 1 | Head initialization |
| `HeadOpened` | 1 | Head opening confirmation |
| `TransactionReceived` | 1 | Transaction received in Head |
| `TransactionAppliedToLocalUTxO` | 1 | Transaction applied locally |
| `SnapshotConfirmed` | 1 | Snapshot confirmed |
| `HeadClosed` | 1 | Head closure |
| `HeadIsReadyToFanout` | 1 | Fanout readiness |
| `HeadFannedOut` | 1 | Fanout completion |
| `NetworkConnected` | 1 | Initial network connection |
| `PeerConnected` | 1 | Peer connection established |

The continuous stream of `TickObserved` events (5,802 ticks) confirms the node maintained uninterrupted synchronization with the Cardano L1 chain throughout the entire testing period.

---

## 5. Uptime Validation Results

| Test Case | Expected Result | Status |
|-----------|-----------------|--------|
| 24-hour continuous operation | Node maintains stable operation for ≥24 hours | ✅ **PASSED** |
| System logs during uptime | Hydra-node and cardano-node logs captured continuously | ✅ **PASSED** |
| No unexpected restarts | Node process runs without crash or restart | ✅ **PASSED** |
| Network connectivity maintained | Consistent connection to Cardano L1 throughout | ✅ **PASSED** |

---

## 6. Conclusion

The Hydra provider node has been successfully deployed and configured. The node demonstrated **stable, uninterrupted operation for the full 24-hour continuous testing period**, meeting the uptime requirement defined in the Milestone 2 acceptance criteria.

The server deployment provides a reliable foundation for developer access and Hydra operations through the Hydra Hub platform.

---

**Related Documents:**
- [Main Evidence Report](../MILESTONE-2-EVIDENCE-REPORT.md)
- [QA Report (EN)](../qa-report/readme.md)
- [QA Report (VI)](../qa-report/readme-vi.md)
