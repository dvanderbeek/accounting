class Reward < ApplicationRecord
  attr_accessor :paid_to, :subscription

  belongs_to :org

  after_create do
    puts "recording reward earned"
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

    puts "recording fee accrued"
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
      onchain_billing_contract.process_transfer(self)
    end

    # Update OCB contract to tell it how much the customer owes in fees
    if accounts.accrued_service_fees.balance > 1 # limit frequency of updates with a threshold of amount owed
      onchain_billing_contract.update(tab: accounts.accrued_service_fees.balance)
    end
  end

  private

  def accounts
    org.accounts_by_name
  end

  def onchain_billing_contract
    OnchainBilling::Contract.find_by(org:)
  end

  # TODO: move this to a separate namespace
  def fee
    # Accrued fees are based on the pricing for this validator, which we know at the time when rewards are earned
    # (from the future Billing service)
    amount.to_d * subscription.fee
  end
end
