# Milestone 2 - Screenshots

Screenshots for Milestone 2: Single Provider Node Deployment & Integration.

All screenshot evidence is stored in [`../milestone-2-evidence/screenshots/`](../milestone-2-evidence/screenshots/).

## Directory Structure

```
screenshots/
├── admin-dashboard/
│   ├── admin-dashboard-node-list.png      # Admin Dashboard - Node list view
│   ├── provider-node-status.png           # Provider node status display
│   └── provider-node-metrics.png          # Provider node performance metrics
├── node-running/
│   ├── node-terminal-running.png.png      # Node terminal running evidence
│   ├── Screenshot from 2026-03-11 18-21-57.png  # Uptime evidence 1
│   └── Screenshot from 2026-03-11 18-22-30.png  # Uptime evidence 2
└── dev-test/
    ├── 1/  (Developer 1 - Nguyen Trang)
    │   ├── dev-head-open/                 # Hydra Head open evidence
    │   ├── UTXO-commited/                 # UTXO commit evidence
    │   ├── dev-transaction/               # Transaction submission evidence
    │   └── dev-fanout/                    # Fanout transaction evidence
    ├── 2/  (Developer 2 - Nam Quan)
    │   ├── dev-head-open/
    │   ├── UTXO-commited/
    │   ├── dev-transaction/
    │   └── dev-fanout/
    ├── 3/  (Developer 3 - Pham Hai)
    │   ├── dev-head-open/
    │   ├── UTXO-commited/
    │   ├── dev-transaction/
    │   └── dev-fanout/
    ├── 4/  (Developer 4 - Quoc Huy)
    │   ├── dev-head-open/
    │   ├── UTXO-commited/
    │   ├── dev-transaction/
    │   └── dev-fanout/
    └── 5/  (Developer 5 - Trinh Cuong)
        ├── dev-head-open/
        ├── UTXO-commited/
        ├── dev-transaction/
        └── dev-fanout/
```

## Screenshot Categories

### Admin Dashboard
- **Node List:** Shows the registered provider node in the Hydra Hub Admin Dashboard
- **Node Status:** Displays the current operational status of the provider node
- **Node Metrics:** Shows runtime performance metrics (CPU, RAM, latency, transactions)

### Node Running
- **Terminal Evidence:** Proof of Hydra node and Cardano node running in terminal
- **Uptime Validation:** Evidence of 24-hour continuous node operation

### Developer Testing
Each of the 5 developers has a dedicated folder containing evidence of completing all 4 Hydra operations:
1. **dev-head-open/** - Opening a Hydra Head
2. **UTXO-commited/** - Committing UTxOs to the Head
3. **dev-transaction/** - Submitting transactions within the Head
4. **dev-fanout/** - Executing fanout to return funds to Layer 1
