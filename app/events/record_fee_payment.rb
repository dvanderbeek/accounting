class RecordFeePayment
  def self.call(amount, from_account, accounts)
    # We know what the accrued fee balance is so we can split it between actual fees & over/under payments
    accrued = accounts.accrued_service_fees.balance
    overpayments = amount - accrued

    Plutus::Entry.create!(
      description: "Pay Actual Validator Fees (With Overpayment)",
      debits: [
        { amount: overpayments, account: accounts.fee_overpayments }, # amount in excess of expected fees gets counted as an asset assuming it will be reimbursed
        { amount: accrued, account: accounts.accrued_service_fees }
      ],
      credits: [
        { amount: amount, account: from_account }
      ]
    )
  end
end
