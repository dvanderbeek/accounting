class OnchainBilling::Contract < ApplicationRecord
  belongs_to :org

  def process_transfer(reward)
    return unless tab > 0

    fee = [reward.amount, tab].min # we don't care about the fee percentage for this specific reward. since we're tracking the customer's balance owed, we can just take the min of that balance or the amount of ETH received by the contract.
    net_reward = reward.amount - fee

    # these would just be smart contract transfers, which we'd index and ultimately populate into these models
    FeePayment.create!(org: org, amount: fee, from_account: org.accounts_by_name.ocb_eth, date: reward.date)
    OcbPayout.create!(amount: net_reward, org:, date: reward.date)

    update(tab: tab - fee)
  end
end
