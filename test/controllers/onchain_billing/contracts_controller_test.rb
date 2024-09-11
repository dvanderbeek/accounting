require "test_helper"

class OnchainBilling::ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @onchain_billing_contract = onchain_billing_contracts(:one)
  end

  test "should get index" do
    get onchain_billing_contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_onchain_billing_contract_url
    assert_response :success
  end

  test "should create onchain_billing_contract" do
    assert_difference("OnchainBilling::Contract.count") do
      post onchain_billing_contracts_url, params: { onchain_billing_contract: { org_id: @onchain_billing_contract.org_id, tab: @onchain_billing_contract.tab } }
    end

    assert_redirected_to onchain_billing_contract_url(OnchainBilling::Contract.last)
  end

  test "should show onchain_billing_contract" do
    get onchain_billing_contract_url(@onchain_billing_contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_onchain_billing_contract_url(@onchain_billing_contract)
    assert_response :success
  end

  test "should update onchain_billing_contract" do
    patch onchain_billing_contract_url(@onchain_billing_contract), params: { onchain_billing_contract: { org_id: @onchain_billing_contract.org_id, tab: @onchain_billing_contract.tab } }
    assert_redirected_to onchain_billing_contract_url(@onchain_billing_contract)
  end

  test "should destroy onchain_billing_contract" do
    assert_difference("OnchainBilling::Contract.count", -1) do
      delete onchain_billing_contract_url(@onchain_billing_contract)
    end

    assert_redirected_to onchain_billing_contracts_url
  end
end
