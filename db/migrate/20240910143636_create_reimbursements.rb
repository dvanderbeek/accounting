class CreateReimbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :reimbursements do |t|
      t.belongs_to :org, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
