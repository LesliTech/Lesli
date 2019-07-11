require 'test_helper'

class AccountPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_plan = account_plans(:one)
  end

  test "should get index" do
    get account_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_account_plan_url
    assert_response :success
  end

  test "should create account_plan" do
    assert_difference('AccountPlan.count') do
      post account_plans_url, params: { account_plan: {  } }
    end

    assert_redirected_to account_plan_url(AccountPlan.last)
  end

  test "should show account_plan" do
    get account_plan_url(@account_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_plan_url(@account_plan)
    assert_response :success
  end

  test "should update account_plan" do
    patch account_plan_url(@account_plan), params: { account_plan: {  } }
    assert_redirected_to account_plan_url(@account_plan)
  end

  test "should destroy account_plan" do
    assert_difference('AccountPlan.count', -1) do
      delete account_plan_url(@account_plan)
    end

    assert_redirected_to account_plans_url
  end
end
