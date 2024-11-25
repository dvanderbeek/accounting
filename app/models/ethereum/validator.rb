class Ethereum::Validator < ApplicationRecord
  belongs_to :onchain_billing_contract, optional: true, class_name: 'OnchainBilling::Contract'
end
