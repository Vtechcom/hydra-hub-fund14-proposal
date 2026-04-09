# Payment Subscription - Aiken Smart Contract

## Overview

This is the Aiken smart contract for the Hydra Hub payment subscription system. The `timed_deposit` validator implements a time-locked payment mechanism with a 24-hour dispute period.

## Contract Details

| Field              | Value                                                      |
| ------------------ | ---------------------------------------------------------- |
| **Name**           | timed_deposit                                              |
| **Script Hash**    | `41631ceb642272fbf20a2de0563b472f0d83cf78ca5c9b5708c94b9f` |
| **Plutus Version** | V3                                                         |
| **Compiler**       | Aiken v1.1.21+42babe5                                      |

## Contract Logic

### Parameters (`TimeDepositParams`)

- `recipient`: Admin wallet verification key hash (receives claimed payments)
- `time_lock`: Dispute period in milliseconds (86400000 = 24 hours)

### Datum Structure

```aiken
pub type Datum {
  sender: VerificationKeyHash,    // User who locked the payment
  deposit_time: Int,              // POSIX timestamp in milliseconds
}
```

### Redeemer Actions

| Action           | Index | Description                           |
| ---------------- | ----- | ------------------------------------- |
| `Refund`         | 0     | Admin refunds payment before deadline |
| `Claim`          | 1     | Admin claims payment after deadline   |
| `ReclaimInvalid` | 2     | Rescue funds with invalid datum       |

### Validation Rules

**Refund (before deadline):**

1. Transaction validity range must be entirely BEFORE deadline
2. Must have admin (recipient) signature
3. Output must go to original sender address

**Claim (after deadline):**

1. Transaction validity range must be entirely AFTER deadline
2. Must have admin (recipient) signature
3. Output must go to admin (recipient) address

**ReclaimInvalid:**

1. Datum must be invalid or missing
2. Must have admin (recipient) signature

## Building

```sh
aiken build
```

## Testing

Run unit tests:

```sh
aiken check
```

Expected output:

```
┍━ timed_deposit ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
│ PASS [mem:   3755, cpu:    1451293] refund_before_deadline
│ PASS [mem:   4259, cpu:    1621007] refund_after_deadline_fails
┕━━━━━━━━━━━━━━━━━━━━━━━━━ 2 tests | 2 passed | 0 failed
```

## File Structure

```
payment-subscription/
├── aiken.toml          # Aiken project configuration
├── plutus.json         # Compiled contract blueprint
├── README.md           # This file
├── validators/
│   ├── timed_deposit.ak  # Main validator logic
│   ├── types.ak          # Type definitions
│   └── params.json       # Contract parameters
└── build/
    └── packages/         # Dependencies
```

## Usage

### 1. Lock Payment (Buy)

User sends ADA to script address with datum:

```json
{
  "sender": "<user_pkh>",
  "deposit_time": 1712505600000
}
```

### 2. Refund (Before Deadline)

Admin can refund within 24 hours using `Refund` redeemer with:

- Validity range ending before deadline
- Output to sender address

### 3. Claim (After Deadline)

Admin claims funds after 24 hours using `Claim` redeemer with:

- Validity range starting after deadline
- Output to admin address

## Verification

Contract can be verified on CardanoScan (Preprod):

- [Script Address](https://preprod.cardanoscan.io/address/addr_test1wpqkx88tvs3897ljpgk7q43mguhsmq700r99ex6hpry5h8c3puxdp)

## Related Documentation

- [Milestone 3 Report](../../milestone-3.md)
- [QA Report](../qa-report/readme.md)

---

_Hydra Hub - Project Catalyst Fund 14_

````

## Documentation

If you're writing a library, you might want to generate an HTML documentation for it.

Use:

```sh
aiken docs
````

## Resources

Find more on the [Aiken's user manual](https://aiken-lang.org).
