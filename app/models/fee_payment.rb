class FeePayment < ApplicationRecord
  attr_accessor :from_account, :accounts

  after_create do
    Plutus::Entry.create!(
      description: "Pay Service Fees",
      debits:,
      credits: [
        { amount: amount, account: from_account }
      ]
    )
  end

  private

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
