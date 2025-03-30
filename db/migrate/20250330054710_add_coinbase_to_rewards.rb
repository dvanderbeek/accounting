class AddCoinbaseToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :coinbase, :boolean
  end
end
