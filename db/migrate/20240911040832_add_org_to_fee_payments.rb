class AddOrgToFeePayments < ActiveRecord::Migration[7.1]
  def change
    remove_column :fee_payments, :org_id, :string
    add_reference :fee_payments, :org, null: false, foreign_key: true
  end
end
