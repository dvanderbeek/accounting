require "application_system_test_case"

class Billing::ProductsTest < ApplicationSystemTestCase
  setup do
    @billing_product = billing_products(:one)
  end

  test "visiting the index" do
    visit billing_products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit billing_products_url
    click_on "New product"

    fill_in "Name", with: @billing_product.name
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "should update Product" do
    visit billing_product_url(@billing_product)
    click_on "Edit this product", match: :first

    fill_in "Name", with: @billing_product.name
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "should destroy Product" do
    visit billing_product_url(@billing_product)
    click_on "Destroy this product", match: :first

    assert_text "Product was successfully destroyed"
  end
end
