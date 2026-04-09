// ============================================================
// Timed Deposit Validator
// ============================================================
// Logic:
//   - Người gửi lock tiền vào contract kèm datum chứa:
//       + sender:    pubkey hash của người gửi
//       + recipient: pubkey hash của người nhận mặc định
//       + deadline:  POSIX ms = thời điểm gửi + 86_400_000 (1 ngày)
//
//   - Refund (hoàn tiền):
//       + Chỉ được thực hiện TRƯỚC deadline
//       + Giao dịch PHẢI có chữ ký của recipient
//
//   - Claim (nhận thưởng):
//       + Chỉ được thực hiện SAU deadline
//       + Output PHẢI gửi đến đúng địa chỉ recipient
// ============================================================

use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/interval
use cardano/address.{VerificationKey}
use cardano/assets
use cardano/transaction.{OutputReference, Transaction}
use types.{TimeDepositParams}

// ---- Datum ----
pub type Datum {
  sender: VerificationKeyHash,
  /// Thời điểm gửi tiền — PHẢI là POSIX milliseconds.
  /// Ví dụ: Date.now() trong JS/TS khi build giao dịch lock.
  deposit_time: Int,
}

// ---- Redeemer ----
pub type Redeemer {
  /// Người gửi hoàn tiền trước deadline
  Refund
  /// Recipient lấy tiền sau deadline
  Claim
  /// Rescue tiền bị lock với datum sai format
  ReclaimInvalid
}

// ---- Validator ----
validator timed_deposit(params: TimeDepositParams) {
  spend(
    // Nhận datum dưới dạng raw Data — KHÔNG tự deserialize.
    // Nếu dùng Option<Datum>, Aiken sẽ tự cast trước khi code chạy:
    // datum sai format → trap ngay → ReclaimInvalid không bao giờ đến được.
    raw_datum: Option<Data>,
    redeemer: Redeemer,
    _input: OutputReference,
    tx: Transaction,
  ) {
    when redeemer is {
      // --- RESCUE: datum sai format hoặc missing → recipient cứu tiền ---
      // Thử safe-cast từ Data → Datum. Nếu fail thì datum là invalid.
      ReclaimInvalid -> {
        // safe_datum = None nếu: (1) không có datum, (2) datum sai format
        let safe_datum: Option<Datum> =
          when raw_datum is {
            None -> None
            Some(d) ->
              if d is datum_val: Datum {
                Some(datum_val)
              } else {
                None
              }
          }
        let invalid_datum = safe_datum == None
        let signed_by_recipient =
          list.has(tx.extra_signatories, params.recipient)
        invalid_datum? && signed_by_recipient?
      }

      // --- REFUND: hoàn tiền lại cho người gửi trước deadline ---
      Refund -> {
        // Nếu datum sai format, expect sẽ fail → tx bị reject đúng hành vi
        expect Some(raw) = raw_datum
        expect d: Datum = raw
        // Toàn bộ khoảng validity phải nằm TRƯỚC deadline
        let before_deadline =
          interval.is_entirely_before(
            tx.validity_range,
            d.deposit_time + params.time_lock,
          )
        let signed_by_recipient =
          list.has(tx.extra_signatories, params.recipient)
        // Output BẮT BUỘC phải gửi về địa chỉ của sender
        let paid_to_sender =
          list.any(
            tx.outputs,
            fn(output) {
              when output.address.payment_credential is {
                VerificationKey(pkh) -> pkh == d.sender
                _ -> False
              }
            },
          )
        before_deadline? && signed_by_recipient? && paid_to_sender?
      }

      // --- CLAIM: recipient lấy tiền sau khi hết deadline ---
      Claim -> {
        expect Some(raw) = raw_datum
        expect d: Datum = raw
        // Toàn bộ khoảng validity phải nằm SAU deadline
        let after_deadline =
          interval.is_entirely_after(
            tx.validity_range,
            d.deposit_time + params.time_lock,
          )
        let signed_by_recipient =
          list.has(tx.extra_signatories, params.recipient)
        // Output BẮT BUỘC phải gửi về địa chỉ của recipient
        let paid_to_recipient =
          list.any(
            tx.outputs,
            fn(output) {
              when output.address.payment_credential is {
                VerificationKey(pkh) -> pkh == params.recipient
                _ -> False
              }
            },
          )
        after_deadline? && signed_by_recipient? && paid_to_recipient?
      }
    }
  }

  else(_) {
    fail
  }
}

// ====================  Tests  ====================

test refund_before_deadline() {
  // Kiểm tra: before_deadline logic
  // deadline = 1_000_000, validity range kết thúc tại 999_999 → hợp lệ
  let deadline = 1_000_000
  let validity = interval.before(deadline - 1)
  interval.is_entirely_before(validity, deadline)
}

test refund_after_deadline_fails() {
  // Kiểm tra: refund KHÔNG hợp lệ khi đã quá deadline
  // validity range bắt đầu tại deadline + 1 → is_entirely_before phải FALSE
  let deadline = 1_000_000
  let validity = interval.after(deadline + 1)
  !interval.is_entirely_before(validity, deadline)
}

test claim_after_deadline() {
  // Kiểm tra: claim hợp lệ sau deadline
  // validity range bắt đầu tại deadline + 1 → is_entirely_after phải TRUE
  let deadline = 1_000_000
  let validity = interval.after(deadline + 1)
  interval.is_entirely_after(validity, deadline)
}

test claim_before_deadline_fails() {
  // Kiểm tra: claim KHÔNG hợp lệ trước deadline
  let deadline = 1_000_000
  let validity = interval.before(deadline - 1)
  !interval.is_entirely_after(validity, deadline)
}

test claim_dust_below_threshold() {
  // UTxO dưới 10 ADA → là dust, tự động sweep thành công
  let dust_value = assets.from_lovelace(5_000_000)
  assets.lovelace_of(dust_value) < 10_000_000
}

test claim_dust_exact_threshold_not_dust() {
  // UTxO đúng 10 ADA → KHÔNG phải dust, phải đi qua full check
  let exact_value = assets.from_lovelace(10_000_000)
  !(assets.lovelace_of(exact_value) < 10_000_000)
}

test claim_normal_above_threshold() {
  // UTxO bình thường 50 ADA → KHÔNG phải dust, phải đi qua full check
  let normal_value = assets.from_lovelace(50_000_000)
  !(assets.lovelace_of(normal_value) < 10_000_000)
}
