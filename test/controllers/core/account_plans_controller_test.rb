require 'test_helper'

class Core::AccountPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_account_plan = core_account_plans(:one)
  end

  test "should get index" do
    get core_account_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_core_account_plan_url
    assert_response :success
  end

  test "should create core_account_plan" do
    assert_difference('Core::AccountPlan.count') do
      post core_account_plans_url, params: { core_account_plan: {  } }
    end

    assert_redirected_to core_account_plan_url(Core::AccountPlan.last)
  end

  test "should show core_account_plan" do
    get core_account_plan_url(@core_account_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_account_plan_url(@core_account_plan)
    assert_response :success
  end

  test "should update core_account_plan" do
    patch core_account_plan_url(@core_account_plan), params: { core_account_plan: {  } }
    assert_redirected_to core_account_plan_url(@core_account_plan)
  end

  test "should destroy core_account_plan" do
    assert_difference('Core::AccountPlan.count', -1) do
      delete core_account_plan_url(@core_account_plan)
    end

    assert_redirected_to core_account_plans_url
  end
end
