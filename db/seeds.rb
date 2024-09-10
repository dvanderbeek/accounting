org = Org.create(name: "Example Org")

# Basic accounting data model: Accounts are the buckets of value (specific types of assets, liabilities, equity, etc)
# Entries keep track of changes to Account balances, each one has n Debits and Credits, which need to balance each other out

# Normal Debit Accounts: Assets + Expenses + Dividends
# Normal Credit Accounts: Liabilities + Equity + Revenue

# Credits and Debits always cancel each other out; so for example, earning revenue has the following entries:
# Debit Cash (increase its balance, since it's a normal debit account)
# Credit Revenue (increase its balance, since it's normal credit account; eventually gets moved to retained earnings)
cash = Plutus::Asset.create(name: "Cash", tenant: org)
# TODO: Create separate accounts for CL and EL Rewards & Income
rewards = Plutus::Asset.create(name: "ETH (Validator Rewards)", tenant: org)
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

Reward.create!(amount: 150, paid_to: ocb_eth, accounts:, subscription:, org:)
Reward.create!(amount: 250, paid_to: rewards, accounts:, subscription:, org:)
FeePayment.create!(org_id: org.id, amount: 5, from_account: cash, accounts:)
FeePayment.create!(org_id: org.id, amount: 32, from_account: ocb_eth, accounts:)
OcbPayout.create!(amount: 118, accounts:, org:)
Reimbursement.create(amount: [0, fee_overpayments.balance].max, org:, accounts:)
FeePayment.create!(org_id: org.id, amount: 45, from_account: cash, accounts:)

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

# reimbursements = fee_overpayments.credits_balance(**args)
reimbursements = Reimbursement.where(org:).sum(:amount)

balance = accrued_service_fees.balance(**args)

# Unreimbursed amount of overpayments
# overpayments_owed = fee_overpayments.balance(**args)
overpayments_owed = overpayments - reimbursements

# Total fees (paid)
fees_paid = FeePayment.where(org_id: org.id).sum(:amount)

# Calculate Net Rewards (cash payouts)
net_rewards_cash = gross_rewards_total - fees_paid

# Calculate Net Rewards (rewards earned - fees accrued)
net_rewards = gross_rewards_total - fee_expenses
# net_rewards = net_rewards_cash + overpayments_owed - balance

# Output the results
puts "-------------------------------------------------"
puts "-- Rewards Statement ----------------------------"
puts "-------------------------------------------------"
puts "Gross Rewards: #{gross_rewards_total}"
puts "-------------------------------------------------"
puts "Fees Accrued (For This Period): #{fee_expenses}"
puts "Fees Paid (For This Period): #{fees_paid}"
puts "-------------------------------------------------"
puts "Overpayment: #{overpayments}"
puts "-------------------------------------------------"
puts "Reimbursements Paid: #{reimbursements}"
puts "Reimbursement Owed: #{overpayments_owed}"
puts "-------------------------------------------------"
puts "Net Rewards (Received): #{net_rewards_cash}"
puts "Net Rewards (Earned): #{net_rewards}"
puts "-------------------------------------------------"
puts "Balance Owed: #{balance}"
puts "-------------------------------------------------"

# Assets = Liabilities + Equity
# expanded: Assets = Liabilities + Equity + Revenue - Expenses
puts "Books Balanced?: #{Plutus::Account.where(tenant: org).trial_balance == 0}"
