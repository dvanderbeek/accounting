class OcbPayout < ApplicationRecord
  belongs_to :org

  after_create do
    puts "recording OCB reward payout"
    # This is the portion of an OCB payout that goes to the customer
    Plutus::Entry.create!(
      date:,
      description: "OCB Payout Sent",
      debits: [
        { amount:, account: accounts.rewards }
      ],
      credits: [
        { amount:, account: accounts.ocb_eth }
      ]
    )
  end

  private

  def accounts
    org.accounts_by_name
  end
end
