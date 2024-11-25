class AddSlotToEthereumBlocks < ActiveRecord::Migration[7.1]
  def change
    add_column :ethereum_blocks, :slot, :bigint
  end
end
