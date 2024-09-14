class OnchainBilling::Contract < ApplicationRecord
  belongs_to :org

  def process_transfer(reward)
    puts "OCB contract received transfer - processing payouts"

    fee = [reward.amount, tab].min # we don't care about the fee percentage for this specific reward. since we're tracking the customer's balance owed, we can just take the min of that balance or the amount of ETH received by the contract.
    net_reward = reward.amount - fee

    # Obviously the contract would not create these records directly
    # these would be smart contract transfers, which we'd index and ultimately populate into these models
    FeePayment.create!(org: org, amount: fee, from_account: org.accounts_by_name.ocb_eth, date: reward.date) if fee.positive?
    OcbPayout.create!(amount: net_reward, org:, date: reward.date) if net_reward.positive?
  end

  def update_tab
    # Update OCB contract to tell it how much the customer owes in fees

    # Instead of doing this whenever rewards are earned or fee payments are made, we could change the contract flow to:
      # Emit an event when a transfer is received
      # listen for that event
      # trigger a payout function with inputs telling it how much the customer's accrued fee balance is

    puts "Updating OCB contract tab"
    update(tab: org.balance_owed) if org.balance_owed
  end
end
