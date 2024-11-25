class CreateEthereumValidators < ActiveRecord::Migration[7.1]
  def change
    create_table :ethereum_validators do |t|
      t.bigint :onchain_index
      t.string :pubkey
      t.string :network

      t.timestamps
    end
  end
end
