class RecordReward
  def self.call(amount, paid_to, accounts, subscription)
    Plutus::Entry.create!(
      description: "Validator Reward",
      debits: [
        { amount: amount, account: paid_to }
      ],
      credits: [
        { amount: amount, account: accounts.validator_income }
      ]
    )

    # Accrued fees are based on the pricing for this validator, which we know at the time when rewards are earned
    # (from the future Billing service)
    fee = amount.to_d * subscription.fee

    Plutus::Entry.create!(
      description: "Accrue Validator Fees",
      debits: [
        { amount: fee, account: accounts.service_fees }
      ],
      credits: [
        { amount: fee, account: accounts.accrued_service_fees }
      ]
    )
  end
end
