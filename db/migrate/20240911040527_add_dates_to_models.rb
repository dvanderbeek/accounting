class AddDatesToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :ocb_payouts, :date, :date
    add_column :fee_payments, :date, :date
    add_column :reimbursements, :date, :date
    add_column :rewards, :date, :date
  end
end
