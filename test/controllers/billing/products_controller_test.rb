require "test_helper"

class Billing::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_product = billing_products(:one)
  end

  test "should get index" do
    get billing_products_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_product_url
    assert_response :success
  end

  test "should create billing_product" do
    assert_difference("Billing::Product.count") do
      post billing_products_url, params: { billing_product: { name: @billing_product.name } }
    end

    assert_redirected_to billing_product_url(Billing::Product.last)
  end

  test "should show billing_product" do
    get billing_product_url(@billing_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_product_url(@billing_product)
    assert_response :success
  end

  test "should update billing_product" do
    patch billing_product_url(@billing_product), params: { billing_product: { name: @billing_product.name } }
    assert_redirected_to billing_product_url(@billing_product)
  end

  test "should destroy billing_product" do
    assert_difference("Billing::Product.count", -1) do
      delete billing_product_url(@billing_product)
    end

    assert_redirected_to billing_products_url
  end
end
