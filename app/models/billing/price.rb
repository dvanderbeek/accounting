class Billing::Price < ApplicationRecord
  belongs_to :product

  def fee(usage_amount_dollars)
    price_per_unit_percent * usage_amount_dollars
  end
end
