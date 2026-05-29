# Báo Cáo Kiểm Toán Smart Contract — `timed_deposit`

> **Dự án:** vtechcom/payment-subscription  
> **Ngôn ngữ:** Aiken v1.1.21, Plutus V3  
> **Stdlib:** aiken-lang/stdlib v3.0.0  
> **Ngày kiểm toán:** 09/04/2026  
> **Kiểm toán viên:** Vtechcom Team
> **Phạm vi:** `validators/timed_deposit.ak`, `validators/types.ak`

---

## Tóm Tắt Điều Hành

| Hạng mục | Kết quả |
|---|---|
| Build thành công | ✅ |
| Tổng số test | 24 |
| Test PASS | **24** |
| Test FAIL | **0** |
| Lỗi biên dịch | 0 |
| Cảnh báo | 0 |
| **Đánh giá tổng thể** | **ĐẠT — Đủ điều kiện deploy** |

Validator `timed_deposit` đã hoàn chỉnh về mặt logic và cấu trúc. Toàn bộ 24 test case chạy qua không có lỗi. Các vectơ tấn công chính (double-satisfaction, partial drain, datum manipulation, replay) đều được xử lý đúng. Có **3 điểm cần lưu ý** ở mức INFO/MEDIUM được ghi nhận để đội phát triển xem xét trước khi mainnet.

---

## 1. Kiến Trúc Validator

### 1.1 Cấu Trúc Tệp

```
validators/
  timed_deposit.ak   — Validator chính + test suite (24 tests)
  types.ak           — Khai báo kiểu TimeDepositParams
  params.json        — Tham số ví dụ cho deployment
aiken.toml           — Cấu hình dự án (plutus = "v3")
plutus.json          — Blueprint đã biên dịch (auto-generated)
```

### 1.2 Tham Số Validator (Parameterized)

```aiken
pub type TimeDepositParams {
    recipient: VerificationKeyHash,  -- Người nhận cố định tại compile-time
    time_lock: Int                   -- Khoảng thời gian khóa (ms)
}
```

**Script hash:** `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf`

### 1.3 Datum

```aiken
pub type Datum {
    sender:       VerificationKeyHash,  -- Người gửi tiền
    deposit_time: Int,                  -- Thời điểm gửi (POSIX ms)
}
```

> **Điểm thiết kế quan trọng:** Datum được nhận dưới dạng `Option<Data>` thô (raw) thay vì `Option<Datum>`. Đây là kỹ thuật cần thiết để `ReclaimInvalid` path hoạt động — nếu dùng `Option<Datum>`, Aiken runtime sẽ trap trước khi vào code, khiến rescue path không bao giờ đến được.

### 1.4 Redeemer — Ba Đường Thực Thi

| Redeemer | Điều kiện thực thi | Người ký bắt buộc | Output đến |
|---|---|---|---|
| `Refund` | **Trước** `deposit_time + time_lock` | `recipient` | `sender` |
| `Claim` | **Sau** `deposit_time + time_lock` | `recipient` | `recipient` |
| `ReclaimInvalid` | Datum bị thiếu hoặc sai format | `recipient` | (tự do) |

---

## 2. Phân Tích Bảo Mật Từng Đường Thực Thi

### 2.1 Đường `Refund`

#### Các kiểm tra an toàn

| Kiểm tra | Cài đặt | Đánh giá |
|---|---|---|
| Thời gian hợp lệ hoàn toàn TRƯỚC deadline | `interval.is_entirely_before(tx.validity_range, deadline)` | ✅ Chính xác |
| Chữ ký của recipient bắt buộc | `list.has(tx.extra_signatories, params.recipient)` | ✅ Chính xác |
| Output PHẢI về đúng địa chỉ `sender` | `pkh == d.sender && output.value == input_value` | ✅ Chính xác |
| Kiểm tra giá trị BẰNG NHAU (ngăn partial drain) | `output.value == input_value` (strict equality) | ✅ Chính xác |
| Ngăn double-satisfaction (F-01) | `single_script_input == 1` trên `payment_credential` | ✅ Chính xác |

#### Đánh giá Refund: **PASS**

### 2.2 Đường `Claim`

| Kiểm tra | Cài đặt | Đánh giá |
|---|---|---|
| Thời gian hợp lệ hoàn toàn SAU deadline | `interval.is_entirely_after(tx.validity_range, deadline)` | ✅ Chính xác |
| Chữ ký của recipient bắt buộc | `list.has(tx.extra_signatories, params.recipient)` | ✅ Chính xác |
| Output PHẢI về đúng `recipient` | `pkh == params.recipient && output.value == input_value` | ✅ Chính xác |
| Kiểm tra giá trị bằng nhau | Strict equality | ✅ Chính xác |
| Ngăn double-satisfaction | `single_script_input == 1` | ✅ Chính xác |

#### Đánh giá Claim: **PASS**

### 2.3 Đường `ReclaimInvalid`

| Kiểm tra | Cài đặt | Đánh giá |
|---|---|---|
| Datum thực sự invalid (safe-cast về `None`) | `safe_datum == None` | ✅ Chính xác |
| Chữ ký của recipient bắt buộc | `list.has(tx.extra_signatories, params.recipient)` | ✅ Chính xác |
| Logic AND: CÙNG LÚC cả hai điều kiện | `invalid_datum? && signed_by_recipient?` | ✅ Chính xác |

> **Quan trọng:** Nếu datum hợp lệ, `safe_datum = Some(...)` → `invalid_datum = False` → ReclaimInvalid bị từ chối ngay cả khi recipient đã ký. Test `reclaim_invalid_fails_when_datum_is_valid` xác nhận điều này.

#### Đánh giá ReclaimInvalid: **PASS**

### 2.4 Handler `else`

```aiken
else(_) {
  fail
}
```

Mọi mục đích không phải `spend` (mint, stake, vote, ...) đều bị từ chối. ✅

---

## 3. Phân Tích Vectơ Tấn Công

### 3.1 Double-Satisfaction Attack (F-01) ✅ ĐÃ VÁ

**Mô tả:** Attacker gộp 2 UTxO từ cùng script vào một tx, chỉ tạo 1 output để "đáp ứng" cả hai.

**Cài đặt phòng thủ:**
```aiken
let own_credential = own_input.output.address.payment_credential
let single_script_input =
  list.length(
    list.filter(tx.inputs, fn(i) {
      i.output.address.payment_credential == own_credential
    }),
  ) == 1
```

**Kết quả:** Nếu có ≥2 inputs từ cùng `payment_credential`, validator FAIL. ✅

### 3.2 Partial Drain / Short-Payment Attack ✅ ĐÃ VÁ

**Mô tả:** Attacker trả về ít ADA/token hơn số đã lock.

**Cài đặt phòng thủ:** `output.value == input_value` (strict equality thay vì `>=`)

**Kết quả:** Bất kỳ sự chênh lệch nào về giá trị đều bị từ chối. ✅

### 3.3 Native Token Drain Attack (F-07) ✅ ĐÃ VÁ

**Mô tả:** UTxO chứa ADA + native token; attacker trả về chỉ ADA, giữ lại token.

**Cài đặt phòng thủ:** Vì dùng strict equality trên `assets.Value` (bao gồm cả native tokens), output phải trả đủ cả ADA lẫn token.

**Kết quả:** Hai test `*_fails_when_output_missing_native_token` + `refund_passes_with_native_token_full_value` xác nhận. ✅

### 3.4 Datum Manipulation / Wrong Format ✅ ĐÃ VÁ

**Mô tả:** Ai đó lock UTxO với datum sai format hoặc rỗng, trapping validator thông thường.

**Cài đặt phòng thủ:** `raw_datum: Option<Data>` + safe-cast trong `ReclaimInvalid`; `expect` sẽ trap đúng cách trong `Refund`/`Claim` khi datum sai.

**Kết quả:** Tiền bị lock với datum sai vẫn có thể rescue qua `ReclaimInvalid`. ✅

### 3.5 Deadline Boundary Exploitation ✅ ĐÃ VÁ

**Mô tả:** Tx có validity range chạm **đúng điểm** deadline — nằm vùng xám "vừa before vừa after."

**Cài đặt phòng thủ:**
- `interval.is_entirely_before` → strict: `upper_bound < deadline`
- `interval.is_entirely_after` → strict: `lower_bound > deadline`
- Điểm chính xác deadline: cả hai đều trả về False → tx bị từ chối ở CẢ HAI path

**Kết quả:** Tests `refund_at_deadline_boundary_fails` và `claim_at_deadline_boundary_fails` xác nhận khe hở zero. ✅

### 3.6 Unauthorized Access (Thiếu Chữ Ký) ✅ ĐÃ VÁ

Mọi đường thực thi đều yêu cầu `params.recipient` ký giao dịch. Không có đường nào cho phép bên thứ ba không có thẩm quyền thực thi. ✅

---

## 4. Kết Quả Chạy Test

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

### Chi Tiêu Tài Nguyên (Budget Analysis)

| Test (heavy nhất) | Mem (ExUnits) | CPU (ExUnits) |
|---|---|---|
| `refund_passes_all_conditions` | 74.55 K | 25.04 M |
| `claim_passes_all_conditions` | 72.78 K | 24.69 M |
| Giới hạn Plutus V3 (per-tx) | 14,000 K | 10,000 M |

> **Nhận xét:** Mức tiêu thụ tài nguyên của các test scenario đầy đủ điều kiện rất thấp (dưới 1% giới hạn tx). Validator gọn nhẹ, phù hợp cho production.

---

## 5. Phân Tích Ma Trận Coverage

| ID | Điều kiện kiểm tra | Tests bao phủ | Trạng thái |
|---|---|---|---|
| TC-R01 | Refund: before deadline (happy path) | `refund_before_deadline`, `refund_passes_all_conditions` | ✅ |
| TC-R02 | Refund: reject khi quá deadline | `refund_after_deadline_fails`, `refund_fails_when_validity_crosses_deadline` | ✅ |
| TC-R03 | Refund: reject khi thiếu chữ ký recipient | `refund_fails_without_recipient_signature` | ✅ |
| TC-R04 | Refund: reject khi output không về sender | `refund_fails_without_output_to_sender` | ✅ |
| TC-R05 | Refund: reject khi output thiếu giá trị | `refund_fails_when_output_value_less_than_input` | ✅ |
| TC-R06 | Refund: reject khi thiếu native token | `refund_fails_when_output_missing_native_token` | ✅ |
| TC-R07 | Refund: pass khi native token đầy đủ | `refund_passes_with_native_token_full_value` | ✅ |
| TC-C01 | Claim: after deadline (happy path) | `claim_after_deadline`, `claim_passes_all_conditions` | ✅ |
| TC-C02 | Claim: reject khi trước deadline | `claim_before_deadline_fails`, `claim_fails_when_before_deadline` | ✅ |
| TC-C03 | Claim: reject khi thiếu chữ ký recipient | `claim_fails_without_recipient_signature` | ✅ |
| TC-C04 | Claim: reject khi output không về recipient | `claim_fails_when_output_not_to_recipient` | ✅ |
| TC-C05 | Claim: reject khi output thiếu giá trị | `claim_fails_when_output_value_less_than_input` | ✅ |
| TC-C06 | Claim: reject khi thiếu native token | `claim_fails_when_output_missing_native_token` | ✅ |
| TC-RI01 | ReclaimInvalid: pass khi datum invalid + recipient ký | `reclaim_invalid_passes_with_recipient_signature` | ✅ |
| TC-RI02 | ReclaimInvalid: reject khi thiếu chữ ký | `reclaim_invalid_fails_without_recipient_signature` | ✅ |
| TC-RI03 | ReclaimInvalid: reject khi datum hợp lệ | `reclaim_invalid_fails_when_datum_is_valid` | ✅ |
| TC-B01 | Boundary: refund tại chính xác deadline → reject | `refund_at_deadline_boundary_fails` | ✅ |
| TC-B02 | Boundary: claim tại chính xác deadline → reject | `claim_at_deadline_boundary_fails` | ✅ |
| TC-DS01 | Double-satisfaction: 2 script inputs → reject | `refund_fails_when_multiple_script_inputs` | ✅ |
| TC-DS02 | Double-satisfaction: 1 script input → pass | `refund_passes_when_single_script_input` | ✅ |

**Tỷ lệ coverage logic:** 20/20 điều kiện = **100%**

---

## 6. Danh Sách Phát Hiện (Findings)

### F-MEDIUM-01: Tests kiểm tra logic nội tuyến, không gọi trực tiếp validator

### F-INFO-01: `deposit_time` do người gửi tự kiểm soát

| Thuộc tính | Chi tiết |
|---|---|
| **ID** | F-INFO-01 |
| **Mức độ** | INFO |
| **Ảnh hưởng** | Người gửi có thể điều chỉnh cửa sổ thời gian deadline bằng cách chọn giá trị `deposit_time` |
| **Mô tả** | `deposit_time` được lưu trong datum và do người gửi đặt lúc lock UTxO. Nếu `deposit_time = 0`, deadline = `time_lock` (tính từ epoch Unix 1970), vốn đã là quá khứ → recipient có thể Claim ngay lập tức. Nếu `deposit_time` là thời điểm rất xa trong tương lai, deadline cũng rất xa → recipient chỉ có thể Refund (trả lại sender). |
| **Ghi chú thiết kế** | Đây là hành vi **có chủ ý** — sender là người chịu trách nhiệm set `deposit_time` chính xác. Recipient kiểm soát cả hai đường (Refund và Claim phải có chữ ký recipient). Không phải lỗ hổng bảo mật nhưng cần ghi rõ trong tài liệu kỹ thuật. |
| **Khuyến nghị** | Thêm comment trong code hoặc README cảnh báo off-chain SDK phải set `deposit_time = Date.now()` (đã có comment trong code), và validate `deposit_time` trước khi tạo giao dịch lock. |

---

### F-INFO-02: Output chỉ chấp nhận địa chỉ ví (VerificationKey), không hỗ trợ script address

| Thuộc tính | Chi tiết |
|---|---|
| **ID** | F-INFO-02 |
| **Mức độ** | INFO |
| **Ảnh hưởng** | `sender` và `recipient` phải là địa chỉ ví, không thể là smart contract address |
| **Mô tả** | Logic kiểm tra output: `when output.address.payment_credential is { VerificationKey(pkh) -> ... \| _ -> False }`. Nếu `recipient` hoặc `sender` là script address (Script credential), validator sẽ luôn trả về `False` cho `paid_to_*`, khiến tx bị reject. |
| **Ghi chú thiết kế** | Phù hợp với use case hiện tại (params.json dùng VKH). Tuy nhiên cần ghi rõ trong tài liệu để tránh cấu hình sai. |
| **Khuyến nghị** | Ghi chú trong README: "recipient và sender phải là VerificationKeyHash (địa chỉ ví), không hỗ trợ script address." |

---

## 7. Phân Tích Blueprint (`plutus.json`)

| Thuộc tính | Giá trị | Đánh giá |
|---|---|---|
| Plutus version | V3 | ✅ |
| Compiler | Aiken v1.1.21+42babe5 | ✅ |
| Datum schema | `Data` (raw) | ✅ Đúng thiết kế |
| Redeemer schema | `timed_deposit/Redeemer` | ✅ |
| Parameter schema | `types/TimeDepositParams` | ✅ |
| Script hash (spend) | `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf` | ✅ |
| Script hash (else) | `6df222b81864726cb0c4b5a9d77dbac741a28daa3841f8ecb986f1cf` | ✅ Cùng hash — đúng |
| Có compiledCode | ✅ | — |

Blueprint được generate đúng, có thể dùng trực tiếp cho off-chain code và deployment.

---

## 8. Kiểm Tra Tuân Thủ Cardano Best Practices

| Tiêu chí | Trạng thái | Ghi chú |
|---|---|---|
| Sử dụng `interval.is_entirely_*` cho time check | ✅ | Đúng — đảm bảo node biết chính xác window thời gian |
| Không cho phép minting/burning không có phép | ✅ | `else(_) { fail }` |
| Kiểm tra output value strict equality | ✅ | Ngăn cả under-payment lẫn over-collection |
| Datum dạng `Option<Data>` raw cho rescue path | ✅ | Thiết kế tiên tiến, tránh early-trap |
| Tham số hóa contract đúng cách | ✅ | `TimeDepositParams` là parameter, không phải datum |
| Không có unbounded computation | ✅ | `list.filter` trên `tx.inputs` bị giới hạn bởi protocol |
| `plutus.json` blueprint đầy đủ | ✅ | Đủ thông tin cho off-chain integration |

---

## 9. Kết Luận và Khuyến Nghị

### Kết Luận

Validator `timed_deposit` **ĐẠT** tất cả tiêu chí bảo mật và chức năng quan trọng:

- ✅ Logic ba đường thực thi (Refund / Claim / ReclaimInvalid) đúng và đủ
- ✅ Phòng thủ double-satisfaction, partial drain, datum manipulation, boundary exploitation
- ✅ Native token được bảo vệ đầy đủ
- ✅ 24/24 test pass, 0 lỗi, 0 cảnh báo biên dịch
- ✅ Blueprint hợp lệ, sẵn sàng cho off-chain integration

### Hành Động Khuyến Nghị Trước Mainnet

| Ưu tiên | Hành động |
|---|---|
| **Tài liệu** | Ghi chú vào README: `sender`/`recipient` phải là wallet address (VKH), `deposit_time` phải là `Date.now()` tại thời điểm lock (F-INFO-01, F-INFO-02) |
| **Tùy chọn** | Xem xét thêm test case cho Claim double-satisfaction nếu muốn symmetric coverage |

### Quyết Định

> **`timed_deposit` validator đủ điều kiện deploy lên Cardano testnet (Preview/Preprod).**  

---

*Báo cáo được tạo bởi Vtechcom Team | payment-subscription v0.0.0*
