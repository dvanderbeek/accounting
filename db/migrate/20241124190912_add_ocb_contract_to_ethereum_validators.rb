class AddOcbContractToEthereumValidators < ActiveRecord::Migration[7.1]
  def change
    add_reference :ethereum_validators, :onchain_billing_contract, null: true, foreign_key: true
  end
end
