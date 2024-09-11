org = Org.create(name: "Example Org")

# Basic accounting data model: Accounts are the buckets of value (specific types of assets, liabilities, equity, etc)
# Entries keep track of changes to Account balances, each one has n Debits and Credits, which need to balance each other out

# Normal Debit Accounts: Assets + Expenses + Dividends
# Normal Credit Accounts: Liabilities + Equity + Revenue

# Credits and Debits always cancel each other out; so for example, earning revenue has the following entries:
# Debit Cash (increase its balance, since it's a normal debit account)
# Credit Revenue (increase its balance, since it's normal credit account; eventually gets moved to retained earnings)
accounts = OpenStruct.new(
  cash: Plutus::Asset.create(name: "Cash", tenant: org),
  # TODO: Create separate accounts for CL and EL Rewards & Income
  rewards: Plutus::Asset.create(name: "ETH (Validator Rewards)", tenant: org),
  ocb_eth: Plutus::Asset.create(name: "ETH (OCB)", tenant: org),
  validator_income: Plutus::Revenue.create(name: "Validator Income", tenant: org),
  service_fees: Plutus::Expense.create(name: "Validator Fees", tenant: org),
  accrued_service_fees: Plutus::Liability.create(name: "Accrued Service Fees", tenant: org),
  fee_overpayments: Plutus::Asset.create(name: "Fee Overpayment Receivables", tenant: org)
)

subscription = Subscription.new(fee: 0.05)

Reward.create!(amount: 150, paid_to: accounts.ocb_eth, accounts:, subscription:, org:)
Reward.create!(amount: 250, paid_to: accounts.rewards, accounts:, subscription:, org:)
FeePayment.create!(org_id: org.id, amount: 5, from_account: accounts.cash, accounts:)
FeePayment.create!(org_id: org.id, amount: 32, from_account: accounts.ocb_eth, accounts:)
OcbPayout.create!(amount: 118, accounts:, org:)
Reimbursement.create(amount: [0, accounts.fee_overpayments.balance].max, org:, accounts:)
FeePayment.create!(org_id: org.id, amount: 45, from_account: accounts.cash, accounts:)

#############################################################################
# Querying the data
#############################################################################
statement = Statement.new(
  start_date: Date.new(2024, 1, 1),
  end_date: Date.new(2024, 12, 31),
  accounts:,
  org:
)

# Output the results
statement.print

# Assets = Liabilities + Equity
# expanded: Assets = Liabilities + Equity + Revenue - Expenses
puts "Books Balanced?: #{Plutus::Account.where(tenant: org).trial_balance == 0}"
