require "test_helper"

class Billing::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_subscription = billing_subscriptions(:one)
  end

  test "should get index" do
    get billing_subscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_subscription_url
    assert_response :success
  end

  test "should create billing_subscription" do
    assert_difference("Billing::Subscription.count") do
      post billing_subscriptions_url, params: { billing_subscription: { org_id: @billing_subscription.org_id, price_id: @billing_subscription.price_id } }
    end

    assert_redirected_to billing_subscription_url(Billing::Subscription.last)
  end

  test "should show billing_subscription" do
    get billing_subscription_url(@billing_subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_subscription_url(@billing_subscription)
    assert_response :success
  end

  test "should update billing_subscription" do
    patch billing_subscription_url(@billing_subscription), params: { billing_subscription: { org_id: @billing_subscription.org_id, price_id: @billing_subscription.price_id } }
    assert_redirected_to billing_subscription_url(@billing_subscription)
  end

  test "should destroy billing_subscription" do
    assert_difference("Billing::Subscription.count", -1) do
      delete billing_subscription_url(@billing_subscription)
    end

    assert_redirected_to billing_subscriptions_url
  end
end
