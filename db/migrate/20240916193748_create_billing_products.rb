class CreateBillingProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_products do |t|
      t.string :name

      t.timestamps
    end
  end
end
