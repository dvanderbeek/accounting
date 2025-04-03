class HomeController < ApplicationController
  before_action :load_org

  attr_reader :org

  def index
    @statement = Statement.new(
      start_date: Date.new(2024, 03, 01).beginning_of_month,
      end_date: Date.current,
      org: @org
    )
    @unswept_rewards = @statement.unswept_rewards
    @gross_rewards_received = @statement.gross_rewards_received
    @ocb_contract = OnchainBilling::Contract.find_by(org: @org)

    # Add pagination with 10 items per page
    @rewards = Reward.order(created_at: :desc)
                    .includes(:paid_to)
                    .paginate(page: params[:rewards_page], per_page: 5)

    @payouts = OcbPayout.order(created_at: :desc)
                        .paginate(page: params[:payouts_page], per_page: 5)

    @fee_payments = FeePayment.order(created_at: :desc)
                              .includes(:from_account)
                              .paginate(page: params[:fees_page], per_page: 5)
  end

  def earn_reward
    amount = (10..300).to_a.sample
    paid_to = if params[:type] == "execution"
                params[:ocb] == "false" ? org.accounts_by_name.rewards : org.accounts_by_name.ocb_eth
              else
                org.accounts_by_name.unswept_rewards
              end
    subscription = org.subscription
    date = Date.current
    coinbase = params[:coinbase] == "true"

    Reward.create!(amount:, paid_to:, subscription:, org:, date:, coinbase:)

    redirect_to root_path
  end

  def pay_fee
    date = Date.current
    amount = org.accounts_by_name.accrued_service_fees.balance

    FeePayment.create!(amount:, from_account: org.accounts_by_name.rewards, org:, date:) # Settles tab so OCB contract tab == 0

    redirect_to root_path
  end

  def sweep
    Sweep.create!(org:)

    redirect_to root_path
  end

  def payout
    onchain_billing_contract = OnchainBilling::Contract.where(org:).first

    onchain_billing_contract.payout!(org.balance_owed)

    redirect_to root_path
  end

  private

  def load_org
    @org ||= Org.first
  end
end
