class CreateOcbPayouts < ActiveRecord::Migration[7.1]
  def change
    create_table :ocb_payouts do |t|
      t.decimal :amount
      t.belongs_to :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
