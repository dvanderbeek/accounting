class CreateBillingSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_subscriptions do |t|
      t.belongs_to :org, null: false, foreign_key: true
      t.belongs_to :price, null: false, foreign_key: { to_table: :billing_prices }

      t.timestamps
    end
  end
end
