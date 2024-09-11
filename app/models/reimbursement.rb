class Reimbursement < ApplicationRecord
  belongs_to :org

  validates :amount, numericality: { greater_than: 0 }

  after_create do
    PaymentGateway.send_payment(amount)

    Plutus::Entry.create!(
      description: "Reimbursement Paid",
      date:,
      debits: [
        { amount: amount, account: accounts.rewards }
      ],
      credits: [
        { amount: amount, account: accounts.fee_overpayments }
      ]
    )
  end

  private

  def accounts
    org.accounts_by_name
  end
end
