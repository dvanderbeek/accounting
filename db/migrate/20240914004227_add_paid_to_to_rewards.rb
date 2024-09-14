class AddPaidToToRewards < ActiveRecord::Migration[7.1]
  def change
    add_reference :rewards, :paid_to, null: false, foreign_key: { to_table: :plutus_accounts }
  end
end
