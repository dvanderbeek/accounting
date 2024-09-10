class ReimburseOverpayments
  def self.call(amount, accounts)
    PaymentGateway.send_payment(amount)

    Plutus::Entry.create!(
      description: "Reimbursement of Overpayment",
      debits: [
        { amount: amount, account: accounts.rewards }
      ],
      credits: [
        { amount: amount, account: accounts.fee_overpayments }
      ]
    )
  end
end
