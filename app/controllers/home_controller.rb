class HomeController < ApplicationController
  def index
    @org = Org.first
    @statement = Statement.new(
      start_date: Date.current.beginning_of_month,
      end_date: Date.current.end_of_month,
      org: @org
    )
    @unswept_rewards = @statement.unswept_rewards
    @gross_rewards_received = @statement.gross_rewards_received
    @ocb_contract = OnchainBilling::Contract.find_by(org: @org)
  end

  def earn_reward
    org = Org.first
    amount = (10..300).to_a.sample
    paid_to = [org.accounts_by_name.ocb_eth, org.accounts_by_name.unswept_rewards].sample
    subscription = org.subscription
    date = Date.current

    Reward.create!(amount:, paid_to:, subscription:, org:, date:)

    redirect_to root_path
  end

  def pay_fee
    org = Org.first
    date = Date.current
    amount = org.accounts_by_name.accrued_service_fees.balance

    FeePayment.create!(amount:, from_account: org.accounts_by_name.rewards, org:, date:) # Settles tab so OCB contract tab == 0

    redirect_to root_path
  end

  def sweep
    org = Org.first

    Sweep.create!(org:)

    redirect_to root_path
  end
end
