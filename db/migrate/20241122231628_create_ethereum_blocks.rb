class CreateEthereumBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :ethereum_blocks do |t|
      t.string :number_hex
      t.string :network

      t.timestamps
    end
  end
end
