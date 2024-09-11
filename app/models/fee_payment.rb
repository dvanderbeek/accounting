class FeePayment < ApplicationRecord
  belongs_to :org

  attr_accessor :from_account

  after_create do
    Plutus::Entry.create!(
      description: "Paid Service Fees",
      date:,
      debits:,
      credits: [
        { amount: amount, account: from_account }
      ]
    )

    OnchainBilling::Contract.find_by(org:).update(tab: accrued)
  end

  private

  def accounts
    org.accounts_by_name
  end

  def accrued
    accounts.accrued_service_fees.balance
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
end
