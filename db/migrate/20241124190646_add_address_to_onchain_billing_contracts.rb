class AddAddressToOnchainBillingContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :onchain_billing_contracts, :address, :string
    add_column :onchain_billing_contracts, :network, :string
  end
end
