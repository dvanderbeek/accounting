class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.decimal :amount
      t.belongs_to :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
