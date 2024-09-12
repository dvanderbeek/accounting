class AddFromAccountToFeePayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :fee_payments, :from_account, null: false, foreign_key: { to_table: :plutus_accounts }
  end
end
