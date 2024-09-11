require "application_system_test_case"

class OnchainBilling::ContractsTest < ApplicationSystemTestCase
  setup do
    @onchain_billing_contract = onchain_billing_contracts(:one)
  end

  test "visiting the index" do
    visit onchain_billing_contracts_url
    assert_selector "h1", text: "Contracts"
  end

  test "should create contract" do
    visit onchain_billing_contracts_url
    click_on "New contract"

    fill_in "Org", with: @onchain_billing_contract.org_id
    fill_in "Tab", with: @onchain_billing_contract.tab
    click_on "Create Contract"

    assert_text "Contract was successfully created"
    click_on "Back"
  end

  test "should update Contract" do
    visit onchain_billing_contract_url(@onchain_billing_contract)
    click_on "Edit this contract", match: :first

    fill_in "Org", with: @onchain_billing_contract.org_id
    fill_in "Tab", with: @onchain_billing_contract.tab
    click_on "Update Contract"

    assert_text "Contract was successfully updated"
    click_on "Back"
  end

  test "should destroy Contract" do
    visit onchain_billing_contract_url(@onchain_billing_contract)
    click_on "Destroy this contract", match: :first

    assert_text "Contract was successfully destroyed"
  end
end
