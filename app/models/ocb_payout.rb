class OcbPayout < ApplicationRecord
  belongs_to :org

  attr_accessor :accounts

  after_create do
    # This is the portion of an OCB payout that goes to the customer
    Plutus::Entry.create!(
      description: "Payout from OCB ETH to ETH Wallet",
      debits: [
        { amount:, account: accounts.rewards }
      ],
      credits: [
        { amount:, account: accounts.ocb_eth }
      ]
    )
  end
end
