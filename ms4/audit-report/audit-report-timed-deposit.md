# Smart Contract Audit Report — `timed_deposit`

> **Project:** vtechcom/payment-subscription  
> **Language:** Aiken v1.1.21, Plutus V3  
> **Stdlib:** aiken-lang/stdlib v3.0.0  
> **Audit Date:** 09/04/2026  
> **Auditors:** Vtechcom Team  
> **Scope:** `validators/timed_deposit.ak`, `validators/types.ak`

---

## Executive Summary

| Item | Result |
|---|---|
| Build successful | ✅ |
| Total tests | 24 |
| Tests PASS | **24** |
| Tests FAIL | **0** |
| Compilation errors | 0 |
| Warnings | 0 |
| **Overall assessment** | **PASS — Ready for deployment** |

The `timed_deposit` validator is logically and structurally complete. All 24 test cases pass without errors. The primary attack vectors (double-satisfaction, partial drain, datum manipulation, replay) are all handled correctly. **3 informational/medium-severity findings** are noted for the development team to review before mainnet deployment.

---

## 1. Validator Architecture

### 1.1 File Structure

```
validators/
  timed_deposit.ak   — Main validator + test suite (24 tests)
  types.ak           — TimeDepositParams type declaration
  params.json        — Example deployment parameters
aiken.toml           — Project configuration (plutus = "v3")
plutus.json          — Compiled blueprint (auto-generated)
```

### 1.2 Validator Parameters (Parameterized)

```aiken
pub type TimeDepositParams {
    recipient: VerificationKeyHash,  -- Fixed recipient set at compile-time
    time_lock: Int                   -- Lock duration (ms)
}
```

**Script hash:** `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf`

### 1.3 Datum

```aiken
pub type Datum {
    sender:       VerificationKeyHash,  -- The party who locked the funds
    deposit_time: Int,                  -- Lock timestamp (POSIX ms)
}
```

> **Key design note:** The datum is received as raw `Option<Data>` rather than `Option<Datum>`. This is required for the `ReclaimInvalid` path to function — if `Option<Datum>` were used, the Aiken runtime would trap before entering the code, making the rescue path unreachable.

### 1.4 Redeemer — Three Execution Paths

| Redeemer | Execution condition | Required signer | Output to |
|---|---|---|---|
| `Refund` | **Before** `deposit_time + time_lock` | `recipient` | `sender` |
| `Claim` | **After** `deposit_time + time_lock` | `recipient` | `recipient` |
| `ReclaimInvalid` | Datum missing or malformed | `recipient` | (unrestricted) |

---

## 2. Security Analysis Per Execution Path

### 2.1 `Refund` Path

#### Safety checks

| Check | Implementation | Assessment |
|---|---|---|
| Validity range entirely BEFORE deadline | `interval.is_entirely_before(tx.validity_range, deadline)` | ✅ Correct |
| Recipient signature required | `list.has(tx.extra_signatories, params.recipient)` | ✅ Correct |
| Output MUST go to `sender` address | `pkh == d.sender && output.value == input_value` | ✅ Correct |
| Value EQUALITY check (prevents partial drain) | `output.value == input_value` (strict equality) | ✅ Correct |
| Double-satisfaction prevention (F-01) | `single_script_input == 1` on `payment_credential` | ✅ Correct |

#### Refund Assessment: **PASS**

### 2.2 `Claim` Path

| Check | Implementation | Assessment |
|---|---|---|
| Validity range entirely AFTER deadline | `interval.is_entirely_after(tx.validity_range, deadline)` | ✅ Correct |
| Recipient signature required | `list.has(tx.extra_signatories, params.recipient)` | ✅ Correct |
| Output MUST go to `recipient` | `pkh == params.recipient && output.value == input_value` | ✅ Correct |
| Value equality check | Strict equality | ✅ Correct |
| Double-satisfaction prevention | `single_script_input == 1` | ✅ Correct |

#### Claim Assessment: **PASS**

### 2.3 `ReclaimInvalid` Path

| Check | Implementation | Assessment |
|---|---|---|
| Datum is genuinely invalid (safe-cast returns `None`) | `safe_datum == None` | ✅ Correct |
| Recipient signature required | `list.has(tx.extra_signatories, params.recipient)` | ✅ Correct |
| AND logic: BOTH conditions must hold simultaneously | `invalid_datum? && signed_by_recipient?` | ✅ Correct |

> **Important:** If the datum is valid, `safe_datum = Some(...)` → `invalid_datum = False` → ReclaimInvalid is rejected even if the recipient has signed. The test `reclaim_invalid_fails_when_datum_is_valid` confirms this.

#### ReclaimInvalid Assessment: **PASS**

### 2.4 `else` Handler

```aiken
else(_) {
  fail
}
```

All non-`spend` purposes (mint, stake, vote, …) are rejected outright. ✅

---

## 3. Attack Vector Analysis

### 3.1 Double-Satisfaction Attack (F-01) ✅ MITIGATED

**Description:** An attacker combines 2 UTxOs from the same script into one transaction, creating only 1 output to "satisfy" both.

**Defense:**
```aiken
let own_credential = own_input.output.address.payment_credential
let single_script_input =
  list.length(
    list.filter(tx.inputs, fn(i) {
      i.output.address.payment_credential == own_credential
    }),
  ) == 1
```

**Result:** If ≥2 inputs share the same `payment_credential`, the validator FAILs. ✅

### 3.2 Partial Drain / Short-Payment Attack ✅ MITIGATED

**Description:** Attacker returns less ADA/tokens than what was locked.

**Defense:** `output.value == input_value` (strict equality instead of `>=`)

**Result:** Any discrepancy in value is rejected. ✅

### 3.3 Native Token Drain Attack (F-07) ✅ MITIGATED

**Description:** UTxO holds ADA + native tokens; attacker returns only ADA, retaining the tokens.

**Defense:** Strict equality on `assets.Value` (which includes native tokens) means the output must return the full ADA and token amounts.

**Result:** Two tests `*_fails_when_output_missing_native_token` + `refund_passes_with_native_token_full_value` confirm this. ✅

### 3.4 Datum Manipulation / Wrong Format ✅ MITIGATED

**Description:** Someone locks a UTxO with a malformed or missing datum, trapping a standard validator.

**Defense:** `raw_datum: Option<Data>` + safe-cast in `ReclaimInvalid`; `expect` traps correctly in `Refund`/`Claim` when the datum is malformed.

**Result:** Funds locked with an invalid datum can still be rescued via `ReclaimInvalid`. ✅

### 3.5 Deadline Boundary Exploitation ✅ MITIGATED

**Description:** A transaction whose validity range touches **exactly** the deadline — sitting in the grey zone of "both before and after."

**Defense:**
- `interval.is_entirely_before` → strict: `upper_bound < deadline`
- `interval.is_entirely_after` → strict: `lower_bound > deadline`
- At the exact deadline point: both return False → tx is rejected on BOTH paths

**Result:** Tests `refund_at_deadline_boundary_fails` and `claim_at_deadline_boundary_fails` confirm a zero-width gap. ✅

### 3.6 Unauthorized Access (Missing Signature) ✅ MITIGATED

Every execution path requires `params.recipient` to sign the transaction. No path permits an unauthorized third party to execute. ✅

---

## 4. Test Run Results

```
┍━ timed_deposit ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
│ PASS [mem: 16.69K, cpu: 5.14M]  refund_before_deadline
│ PASS [mem: 12.65K, cpu: 3.50M]  refund_after_deadline_fails
│ PASS [mem: 15.03K, cpu: 4.73M]  claim_after_deadline
│ PASS [mem: 11.81K, cpu: 3.29M]  claim_before_deadline_fails
│ PASS [mem: 74.55K, cpu: 25.04M] refund_passes_all_conditions
│ PASS [mem: 39.76K, cpu: 12.35M] refund_fails_when_validity_crosses_deadline
│ PASS [mem: 36.23K, cpu: 10.98M] refund_fails_without_recipient_signature
│ PASS [mem: 43.29K, cpu: 13.28M] refund_fails_without_output_to_sender
│ PASS [mem: 72.78K, cpu: 24.69M] claim_passes_all_conditions
│ PASS [mem: 39.23K, cpu: 12.19M] claim_fails_when_before_deadline
│ PASS [mem: 36.23K, cpu: 10.98M] claim_fails_without_recipient_signature
│ PASS [mem: 41.99K, cpu: 12.92M] claim_fails_when_output_not_to_recipient
│ PASS [mem: 54.74K, cpu: 17.76M] refund_fails_when_output_value_less_than_input
│ PASS [mem: 54.24K, cpu: 17.76M] claim_fails_when_output_value_less_than_input
│ PASS [mem: 19.31K, cpu: 6.01M]  reclaim_invalid_passes_with_recipient_signature
│ PASS [mem: 16.89K, cpu: 5.17M]  reclaim_invalid_fails_without_recipient_signature
│ PASS [mem: 16.38K, cpu: 5.28M]  reclaim_invalid_fails_when_datum_is_valid
│ PASS [mem: 19.76K, cpu: 6.02M]  refund_at_deadline_boundary_fails
│ PASS [mem: 18.09K, cpu: 5.60M]  claim_at_deadline_boundary_fails
│ PASS [mem: 51.60K, cpu: 16.84M] refund_fails_when_multiple_script_inputs
│ PASS [mem: 27.75K, cpu: 8.81M]  refund_passes_when_single_script_input
│ PASS [mem: 50.52K, cpu: 15.18M] refund_fails_when_output_missing_native_token
│ PASS [mem: 40.26K, cpu: 13.19M] refund_passes_with_native_token_full_value
│ PASS [mem: 50.52K, cpu: 15.18M] claim_fails_when_output_missing_native_token
┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 24 tests | 24 passed | 0 failed

Summary 24 checks, 0 errors, 0 warnings
```

### Resource Consumption (Budget Analysis)

| Test (heaviest) | Mem (ExUnits) | CPU (ExUnits) |
|---|---|---|
| `refund_passes_all_conditions` | 74.55 K | 25.04 M |
| `claim_passes_all_conditions` | 72.78 K | 24.69 M |
| Plutus V3 limit (per-tx) | 14,000 K | 10,000 M |

> **Note:** Resource consumption in fully-conditioned test scenarios is very low (under 1% of the transaction limit). The validator is lean and well-suited for production.

---

## 5. Coverage Matrix Analysis

| ID | Condition under test | Covering tests | Status |
|---|---|---|---|
| TC-R01 | Refund: before deadline (happy path) | `refund_before_deadline`, `refund_passes_all_conditions` | ✅ |
| TC-R02 | Refund: reject when past deadline | `refund_after_deadline_fails`, `refund_fails_when_validity_crosses_deadline` | ✅ |
| TC-R03 | Refund: reject when recipient signature missing | `refund_fails_without_recipient_signature` | ✅ |
| TC-R04 | Refund: reject when output not sent to sender | `refund_fails_without_output_to_sender` | ✅ |
| TC-R05 | Refund: reject when output value insufficient | `refund_fails_when_output_value_less_than_input` | ✅ |
| TC-R06 | Refund: reject when native token missing | `refund_fails_when_output_missing_native_token` | ✅ |
| TC-R07 | Refund: pass when native token value is full | `refund_passes_with_native_token_full_value` | ✅ |
| TC-C01 | Claim: after deadline (happy path) | `claim_after_deadline`, `claim_passes_all_conditions` | ✅ |
| TC-C02 | Claim: reject when before deadline | `claim_before_deadline_fails`, `claim_fails_when_before_deadline` | ✅ |
| TC-C03 | Claim: reject when recipient signature missing | `claim_fails_without_recipient_signature` | ✅ |
| TC-C04 | Claim: reject when output not sent to recipient | `claim_fails_when_output_not_to_recipient` | ✅ |
| TC-C05 | Claim: reject when output value insufficient | `claim_fails_when_output_value_less_than_input` | ✅ |
| TC-C06 | Claim: reject when native token missing | `claim_fails_when_output_missing_native_token` | ✅ |
| TC-RI01 | ReclaimInvalid: pass when datum invalid + recipient signed | `reclaim_invalid_passes_with_recipient_signature` | ✅ |
| TC-RI02 | ReclaimInvalid: reject when signature missing | `reclaim_invalid_fails_without_recipient_signature` | ✅ |
| TC-RI03 | ReclaimInvalid: reject when datum is valid | `reclaim_invalid_fails_when_datum_is_valid` | ✅ |
| TC-B01 | Boundary: refund at exact deadline → reject | `refund_at_deadline_boundary_fails` | ✅ |
| TC-B02 | Boundary: claim at exact deadline → reject | `claim_at_deadline_boundary_fails` | ✅ |
| TC-DS01 | Double-satisfaction: 2 script inputs → reject | `refund_fails_when_multiple_script_inputs` | ✅ |
| TC-DS02 | Double-satisfaction: 1 script input → pass | `refund_passes_when_single_script_input` | ✅ |

**Logic coverage rate:** 20/20 conditions = **100%**

---

## 6. Findings

### F-MEDIUM-01: Tests validate inline logic, not direct validator calls

Tests exercise the validator's internal logic directly rather than invoking the compiled validator entry point end-to-end. This is standard practice for Aiken unit testing but means integration-level behavior (e.g., script-context construction by the ledger) is not covered by these tests alone. Pre-mainnet testing on Preview/Preprod testnet is recommended to close this gap.

---

### F-INFO-01: `deposit_time` is controlled by the sender

| Attribute | Detail |
|---|---|
| **ID** | F-INFO-01 |
| **Severity** | INFO |
| **Impact** | The sender can adjust the deadline window by choosing the value of `deposit_time` |
| **Description** | `deposit_time` is stored in the datum and set by the sender when locking the UTxO. If `deposit_time = 0`, deadline = `time_lock` (measured from Unix epoch 1970), which is already in the past — meaning the recipient can Claim immediately. If `deposit_time` is set far in the future, the deadline is also far away, so the recipient can only Refund (return to sender) until that time. |
| **Design note** | This is **intentional behavior** — the sender bears responsibility for setting `deposit_time` accurately. The recipient controls both paths (both Refund and Claim require the recipient's signature). This is not a security vulnerability but should be clearly documented. |
| **Recommendation** | Add a comment in the code or README warning that off-chain SDKs must set `deposit_time = Date.now()` at the time of locking (a comment already exists in the code), and validate `deposit_time` before constructing the lock transaction. |

---

### F-INFO-02: Output only accepts wallet addresses (VerificationKey), script addresses not supported

| Attribute | Detail |
|---|---|
| **ID** | F-INFO-02 |
| **Severity** | INFO |
| **Impact** | `sender` and `recipient` must be wallet addresses; smart contract addresses are not supported |
| **Description** | Output validation logic: `when output.address.payment_credential is { VerificationKey(pkh) -> ... \| _ -> False }`. If `recipient` or `sender` is a script address (Script credential), the validator will always return `False` for `paid_to_*`, causing the transaction to be rejected. |
| **Design note** | This is appropriate for the current use case (`params.json` uses VKH). However, this limitation should be clearly documented to prevent misconfiguration. |
| **Recommendation** | Add a note in the README: "Both `recipient` and `sender` must be VerificationKeyHash (wallet addresses); script addresses are not supported." |

---

## 7. Blueprint Analysis (`plutus.json`)

| Attribute | Value | Assessment |
|---|---|---|
| Plutus version | V3 | ✅ |
| Compiler | Aiken v1.1.21+42babe5 | ✅ |
| Datum schema | `Data` (raw) | ✅ Correct by design |
| Redeemer schema | `timed_deposit/Redeemer` | ✅ |
| Parameter schema | `types/TimeDepositParams` | ✅ |
| Script hash (spend) | `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf` | ✅ |
| Script hash (else) | `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf` | ✅ Same hash — correct |
| compiledCode present | ✅ | — |

The blueprint is correctly generated and can be used directly for off-chain code and deployment.

---

## 8. Cardano Best Practices Compliance

| Criterion | Status | Notes |
|---|---|---|
| Uses `interval.is_entirely_*` for time checks | ✅ | Correct — ensures the node knows the precise time window |
| No unauthorized minting/burning | ✅ | `else(_) { fail }` |
| Output value checked with strict equality | ✅ | Prevents both under-payment and over-collection |
| Datum as raw `Option<Data>` for rescue path | ✅ | Advanced design pattern, avoids early-trap |
| Contract properly parameterized | ✅ | `TimeDepositParams` is a parameter, not a datum |
| No unbounded computation | ✅ | `list.filter` on `tx.inputs` is bounded by protocol limits |
| `plutus.json` blueprint complete | ✅ | Sufficient for off-chain integration |

---

## 9. Conclusions and Recommendations

### Conclusion

The `timed_deposit` validator **PASSES** all critical security and functional criteria:

- ✅ Three execution paths (Refund / Claim / ReclaimInvalid) are correct and complete
- ✅ Defenses against double-satisfaction, partial drain, datum manipulation, and boundary exploitation
- ✅ Native tokens are fully protected
- ✅ 24/24 tests pass, 0 errors, 0 compilation warnings
- ✅ Valid blueprint, ready for off-chain integration

### Recommended Actions Before Mainnet

| Priority | Action |
|---|---|
| **Documentation** | Add README notes: `sender`/`recipient` must be wallet addresses (VKH); `deposit_time` must be `Date.now()` at the time of locking (F-INFO-01, F-INFO-02) |
| **Optional** | Consider adding a Claim double-satisfaction test case for symmetric coverage |

### Decision

> **The `timed_deposit` validator is cleared for deployment on the Cardano testnet (Preview/Preprod).**

---

*Report generated by Vtechcom Team | payment-subscription v0.0.0*
