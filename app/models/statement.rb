class Statement
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :accounts, :org

  # Find the relevant accounts
  def args
    { from_date: start_date, to_date: end_date }
  end

  # Calculate Gross Rewards
  def gross_rewards_total
    accounts.validator_income.balance(**args)
  end

  # Total fee expense
  def fee_expenses
    accounts.service_fees.balance(**args)
  end

  # Total paid in excess of fee expense
  def overpayments
    accounts.fee_overpayments.debits_balance(**args)
  end

  # def reimbursements
  #   fee_overpayments.credits_balance(**args)
  # end
  def reimbursements
    Reimbursement.where(org:).sum(:amount)
  end

  def balance
    accounts.accrued_service_fees.balance(**args)
  end

  # Unreimbursed amount of overpayments
  # def overpayments_owed
  #   fee_overpayments.balance(**args)
  # end
  def overpayments_owed
    overpayments - reimbursements
  end

  # Total fees (paid)
  def fees_paid
    FeePayment.where(org_id: org.id).sum(:amount)
  end

  # Calculate Net Rewards (cash payouts)
  def net_rewards_cash
    gross_rewards_total - fees_paid + reimbursements
  end

  # Calculate Net Rewards (rewards earned - fees accrued)
  def net_rewards
    gross_rewards_total - fee_expenses
  end
  # net_rewards = net_rewards_cash + overpayments_owed - balance

  def print
    puts "-------------------------------------------------"
    puts "-- Rewards Statement ----------------------------"
    puts "-------------------------------------------------"
    puts "Gross Rewards: #{gross_rewards_total}"
    puts "-------------------------------------------------"
    puts "Fees Paid (For This Period): #{fees_paid}"
    puts "- Fees Accrued (For This Period): #{fee_expenses}"
    puts "= Overpayment: #{overpayments}"
    puts "    Reimbursed: #{reimbursements}"
    puts "    Reimbursements Owed: #{overpayments_owed}"
    puts "-------------------------------------------------"
    puts "Net Rewards (Received): #{net_rewards_cash}"
    puts "+ Reimbursements Owed: #{overpayments_owed}"
    puts "= Net Rewards (Earned): #{net_rewards}"
    puts "-------------------------------------------------"
    puts "Balance Owed: #{balance}"
    puts "-------------------------------------------------"
  end
end
