class CreateBillingPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_prices do |t|
      t.belongs_to :product, null: false, foreign_key: { to_table: :billing_products }
      t.string :name
      t.string :billing_scheme
      t.integer :price_per_unit_cents
      t.string :currency

      t.timestamps
    end
  end
end
