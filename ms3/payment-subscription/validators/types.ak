use aiken/crypto.{VerificationKeyHash}

pub type TimeDepositParams {
    recipient: VerificationKeyHash,
    time_lock: Int
}