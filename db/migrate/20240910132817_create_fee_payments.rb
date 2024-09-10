class CreateFeePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :fee_payments do |t|
      t.string :org_id
      t.decimal :amount

      t.timestamps
    end
  end
end
