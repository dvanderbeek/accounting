class Reward < ApplicationRecord
  include OcbScopes

  attr_accessor :subscription
  belongs_to :paid_to, class_name: 'Plutus::Account'

  belongs_to :org

  ocb_scopes :paid_to

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

    onchain_billing_contract.update_tab
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
