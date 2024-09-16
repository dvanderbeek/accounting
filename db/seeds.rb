org = Org.create(name: "Example Org")

# Basic accounting data model: Accounts are the buckets of value (specific types of assets, liabilities, equity, etc)
# Entries keep track of changes to Account balances, each one has n Debits and Credits, which need to balance each other out

# Normal Debit Accounts: Assets + Expenses + Dividends
# Normal Credit Accounts: Liabilities + Equity + Revenue

# Credits and Debits always cancel each other out; so for example, earning revenue has the following entries:
# Debit Cash (increase its balance, since it's a normal debit account)
# Credit Revenue (increase its balance, since it's normal credit account; eventually gets moved to retained earnings)

accounts = OpenStruct.new(
  # TODO: Create separate accounts for CL and EL Rewards & Income (or just add type to Reward model)
  rewards: Plutus::Asset.create(name: "rewards", tenant: org),
  ocb_eth: Plutus::Asset.create(name: "ocb_eth", tenant: org),
  validator_income: Plutus::Revenue.create(name: "validator_income", tenant: org),
  service_fees: Plutus::Expense.create(name: "service_fees", tenant: org),
  accrued_service_fees: Plutus::Liability.create(name: "accrued_service_fees", tenant: org),
  fee_overpayments: Plutus::Asset.create(name: "fee_overpayments", tenant: org)
)

# Set up mock OCB Contract that uses a "tab" model to collect exact fees owed instead of an approximation
OnchainBilling::Contract.create(tab: 0, org:)

date = Date.current

product = Billing::Product.create(name: "ETH Validator Staking")
price = Billing::Price.create(name: 'Standard 5%', product:, price_per_unit_percent: 0.05, currency: 'ETH', billing_scheme: 'usage_based')
subscription = Billing::Subscription.create(org:, price:)

Reward.create!(amount: 150, paid_to: accounts.ocb_eth, subscription:, org:, date:)
Reward.create!(amount: 250, paid_to: accounts.rewards, subscription:, org:, date:)
FeePayment.create!(amount: 5, from_account: accounts.rewards, org: org, date:)
Reward.create!(amount: 10, paid_to: accounts.ocb_eth, subscription:, org:, date:)
Reward.create!(amount: 90, paid_to: accounts.ocb_eth, subscription:, org:, date:)
# FeePayment.create!(amount: 4.5, from_account: accounts.rewards, org: org, date:) # Settles tab so OCB contract tab == 0

#############################################################################
# Querying the data
#############################################################################
statement = Statement.new(
  start_date: Date.new(2024, 1, 1),
  end_date: Date.new(2024, 12, 31),
  org:
)

# Output the results
statement.print

# Assets = Liabilities + Equity
# expanded: Assets = Liabilities + Equity + Revenue - Expenses
puts "Books Balanced?: #{Plutus::Account.where(tenant: org).trial_balance == 0}"
