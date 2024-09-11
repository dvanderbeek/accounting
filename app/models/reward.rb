class Reward < ApplicationRecord
  attr_accessor :paid_to, :subscription

  belongs_to :org

  after_create do
    Plutus::Entry.create!(
      description: "Validator Reward Earned",
      date:,
      debits: [
        { amount: amount, account: paid_to }
      ],
      credits: [
        { amount: amount, account: accounts.validator_income }
      ]
    )

    Plutus::Entry.create!(
      description: "Service Fees Accrued",
      date:,
      debits: [
        { amount: fee, account: accounts.service_fees }
      ],
      credits: [
        { amount: fee, account: accounts.accrued_service_fees }
      ]
    )

    # Simulate the OCB Contract getting a payment
    if paid_to.name == 'ocb_eth'
      OnchainBilling::Contract.last.process_transfer(self)
    end
  end

  private

  def accounts
    org.accounts_by_name
  end

  # TODO: move this to a separate namespace
  def fee
    # Accrued fees are based on the pricing for this validator, which we know at the time when rewards are earned
    # (from the future Billing service)
    amount.to_d * subscription.fee
  end
end
