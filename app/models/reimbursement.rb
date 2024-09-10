class Reimbursement < ApplicationRecord
  belongs_to :org

  attr_accessor :accounts

  validates :amount, numericality: { greater_than: 0 }

  after_create do
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
