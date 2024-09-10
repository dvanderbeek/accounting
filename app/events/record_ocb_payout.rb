class RecordOcbPayout
  def self.call(reward, accounts)
    # This is the portion of an OCB payout that goes to the customer
    Plutus::Entry.create!(
      description: "Payout from OCB ETH to ETH Wallet",
      debits: [
        { amount: reward, account: accounts.rewards }
      ],
      credits: [
        { amount: reward, account: accounts.ocb_eth }
      ]
    )
  end
end
