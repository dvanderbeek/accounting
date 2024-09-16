require "test_helper"

class Billing::PricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_price = billing_prices(:one)
  end

  test "should get index" do
    get billing_prices_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_price_url
    assert_response :success
  end

  test "should create billing_price" do
    assert_difference("Billing::Price.count") do
      post billing_prices_url, params: { billing_price: { billing_scheme: @billing_price.billing_scheme, currency: @billing_price.currency, name: @billing_price.name, price_per_unit_cents: @billing_price.price_per_unit_cents, product_id: @billing_price.product_id } }
    end

    assert_redirected_to billing_price_url(Billing::Price.last)
  end

  test "should show billing_price" do
    get billing_price_url(@billing_price)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_price_url(@billing_price)
    assert_response :success
  end

  test "should update billing_price" do
    patch billing_price_url(@billing_price), params: { billing_price: { billing_scheme: @billing_price.billing_scheme, currency: @billing_price.currency, name: @billing_price.name, price_per_unit_cents: @billing_price.price_per_unit_cents, product_id: @billing_price.product_id } }
    assert_redirected_to billing_price_url(@billing_price)
  end

  test "should destroy billing_price" do
    assert_difference("Billing::Price.count", -1) do
      delete billing_price_url(@billing_price)
    end

    assert_redirected_to billing_prices_url
  end
end
