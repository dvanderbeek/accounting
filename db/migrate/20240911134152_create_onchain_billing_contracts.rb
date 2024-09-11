class CreateOnchainBillingContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :onchain_billing_contracts do |t|
      t.decimal :tab
      t.belongs_to :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
