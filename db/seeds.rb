org = Org.create(name: "Example Org")

# Basic accounting data model: Accounts are the buckets of value (specific types of assets, liabilities, equity, etc)
# Entries keep track of changes to Account balances, each one has n Debits and Credits, which need to balance each other out

# Normal Debit Accounts: Assets + Expenses + Dividends
# Normal Credit Accounts: Liabilities + Equity + Revenue

# Credits and Debits always cancel each other out; so for example, earning revenue has the following entries:
# Debit Cash (increase its balance, since it's a normal debit account)
# Credit Revenue (increase its balance, since it's normal credit account; eventually gets moved to retained earnings)
cash = Plutus::Asset.create(name: "Cash", tenant: org)
rewards = Plutus::Asset.create(name: "ETH (Validator Income)", tenant: org)
ocb_eth = Plutus::Asset.create(name: "ETH (OCB)", tenant: org)
validator_income = Plutus::Revenue.create(name: "Validator Income", tenant: org)
service_fees = Plutus::Expense.create(name: "Validator Fees", tenant: org)
accrued_service_fees = Plutus::Liability.create(name: "Accrued Service Fees", tenant: org)
fee_overpayments = Plutus::Asset.create(name: "Fee Overpayment Receivables", tenant: org)

accounts = OpenStruct.new(
  rewards:,
  ocb_eth:,
  validator_income:,
  service_fees:,
  accrued_service_fees:,
  fee_overpayments:
)

subscription = Subscription.new(fee: 0.2)

RecordReward.call(150, ocb_eth, accounts, subscription)
RecordFeePayment.call(5, cash, accounts)
RecordFeePayment.call(32, ocb_eth, accounts)
RecordOcbPayout.call(118, accounts)
ReimburseOverpayments.call(5, accounts)

#############################################################################
# Querying the data
#############################################################################

start_date = Date.new(2024, 1, 1)
end_date = Date.new(2024, 12, 31)

# Find the relevant accounts
args = { from_date: start_date, to_date: end_date }

# Calculate Gross Rewards
gross_rewards_total = validator_income.balance(**args)

# Total fee expense
fee_expenses = service_fees.balance(**args)

# Total paid in excess of fee expense
overpayments = fee_overpayments.debits_balance(**args)

reimbursements = fee_overpayments.credits_balance(**args)

# Unreimbursed amount of overpayments
# overpayments_owed = fee_overpayments.balance(**args)
overpayments_owed = overpayments - reimbursements

# Total fees (paid)
fees_paid = fee_expenses + overpayments_owed

# Calculate Net Rewards (cash payouts)
net_rewards_cash = gross_rewards_total - fees_paid

# Calculate Net Rewards (rewards earned - fees accrued)
# net_rewards = gross_rewards_total - fee_expenses
net_rewards = net_rewards_cash + overpayments_owed

# Output the results
puts "Gross Rewards: #{gross_rewards_total}"
puts "Fees Paid (gross): #{fee_expenses + overpayments}"
puts "Overpayments Reimbursed: #{reimbursements}"
puts "Fees Paid (net): #{fees_paid}"
puts "Fees Accrued: #{fee_expenses}"
puts "Reimbursement Owed: #{overpayments_owed}"
puts "Net Rewards (cash): #{net_rewards_cash}"
puts "Net Rewards: #{net_rewards}"
puts "Overpayments (total, including reimbursed): #{overpayments}"

# Assets = Liabilities + Equity
# expanded: Assets = Liabilities + Equity + Revenue - Expenses
puts "Books Balanced?: #{Plutus::Account.where(tenant: org).trial_balance == 0}"
