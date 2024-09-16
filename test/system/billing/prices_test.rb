require "application_system_test_case"

class Billing::PricesTest < ApplicationSystemTestCase
  setup do
    @billing_price = billing_prices(:one)
  end

  test "visiting the index" do
    visit billing_prices_url
    assert_selector "h1", text: "Prices"
  end

  test "should create price" do
    visit billing_prices_url
    click_on "New price"

    fill_in "Billing scheme", with: @billing_price.billing_scheme
    fill_in "Currency", with: @billing_price.currency
    fill_in "Name", with: @billing_price.name
    fill_in "Price per unit cents", with: @billing_price.price_per_unit_cents
    fill_in "Product", with: @billing_price.product_id
    click_on "Create Price"

    assert_text "Price was successfully created"
    click_on "Back"
  end

  test "should update Price" do
    visit billing_price_url(@billing_price)
    click_on "Edit this price", match: :first

    fill_in "Billing scheme", with: @billing_price.billing_scheme
    fill_in "Currency", with: @billing_price.currency
    fill_in "Name", with: @billing_price.name
    fill_in "Price per unit cents", with: @billing_price.price_per_unit_cents
    fill_in "Product", with: @billing_price.product_id
    click_on "Update Price"

    assert_text "Price was successfully updated"
    click_on "Back"
  end

  test "should destroy Price" do
    visit billing_price_url(@billing_price)
    click_on "Destroy this price", match: :first

    assert_text "Price was successfully destroyed"
  end
end
