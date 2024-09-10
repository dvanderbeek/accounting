class Reward < ApplicationRecord
  attr_accessor :accounts, :paid_to, :subscription

  belongs_to :org

  after_create do
    Plutus::Entry.create!(
      description: "Validator Reward",
      debits: [
        { amount: amount, account: paid_to }
      ],
      credits: [
        { amount: amount, account: accounts.validator_income }
      ]
    )

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

  private

  # TODO: move this to a separate namespace
  def fee
    # Accrued fees are based on the pricing for this validator, which we know at the time when rewards are earned
    # (from the future Billing service)
    amount.to_d * subscription.fee
  end
end
