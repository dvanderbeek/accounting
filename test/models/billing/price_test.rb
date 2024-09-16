require "test_helper"

class Billing::PriceTest < ActiveSupport::TestCase
  test "#fee" do
    reward = 100
    price = billing_prices(:two)
    assert_equal price.fee(reward), price.price_per_unit_cents * reward
  end
end
