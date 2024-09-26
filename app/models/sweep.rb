class Sweep
  def self.create!(org:)
    puts "recording reward sweep"
    amount = org.accounts_by_name.unswept_rewards.balance
    Plutus::Entry.create!(
      description: "Validator Rewards Swept",
      date: Date.current,
      debits: [
        { amount: amount, account: org.accounts_by_name.rewards }
      ],
      credits: [
        { amount: amount, account: org.accounts_by_name.unswept_rewards }
      ]
    )
  end
end
