class FeePayment < ApplicationRecord
  include OcbScopes
  belongs_to :org
  belongs_to :from_account, class_name: 'Plutus::Account'

  validates :amount, numericality: { greater_than: 0 }

  ocb_scopes :from_account

  after_create do
    puts "recording fee payment of #{amount} from #{from_account.name}"
    Plutus::Entry.create!(
      description: "Paid Service Fees",
      date:,
      debits:,
      credits: [
        { amount: amount, account: from_account }
      ]
    )

    onchain_billing_contract.update_tab
  end

  private

  def accounts
    @accounts ||= org.accounts_by_name
  end

  def accrued
    @accrued ||= accounts.accrued_service_fees.balance
  end

  def debits
    if amount > accrued
      [
        { amount: amount - accrued, account: accounts.fee_overpayments },
        { amount: accrued, account: accounts.accrued_service_fees }
      ]
    else
      [{ amount: amount, account: accounts.accrued_service_fees }]
    end
  end

  def onchain_billing_contract
    OnchainBilling::Contract.find_by(org:)
  end
end
