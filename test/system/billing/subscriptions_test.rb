require "application_system_test_case"

class Billing::SubscriptionsTest < ApplicationSystemTestCase
  setup do
    @billing_subscription = billing_subscriptions(:one)
  end

  test "visiting the index" do
    visit billing_subscriptions_url
    assert_selector "h1", text: "Subscriptions"
  end

  test "should create subscription" do
    visit billing_subscriptions_url
    click_on "New subscription"

    fill_in "Org", with: @billing_subscription.org_id
    fill_in "Price", with: @billing_subscription.price_id
    click_on "Create Subscription"

    assert_text "Subscription was successfully created"
    click_on "Back"
  end

  test "should update Subscription" do
    visit billing_subscription_url(@billing_subscription)
    click_on "Edit this subscription", match: :first

    fill_in "Org", with: @billing_subscription.org_id
    fill_in "Price", with: @billing_subscription.price_id
    click_on "Update Subscription"

    assert_text "Subscription was successfully updated"
    click_on "Back"
  end

  test "should destroy Subscription" do
    visit billing_subscription_url(@billing_subscription)
    click_on "Destroy this subscription", match: :first

    assert_text "Subscription was successfully destroyed"
  end
end
