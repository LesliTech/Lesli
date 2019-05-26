require 'test_helper'

class Core::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_account = core_accounts(:one)
  end

  test "should get index" do
    get core_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_core_account_url
    assert_response :success
  end

  test "should create core_account" do
    assert_difference('Core::Account.count') do
      post core_accounts_url, params: { core_account: {  } }
    end

    assert_redirected_to core_account_url(Core::Account.last)
  end

  test "should show core_account" do
    get core_account_url(@core_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_account_url(@core_account)
    assert_response :success
  end

  test "should update core_account" do
    patch core_account_url(@core_account), params: { core_account: {  } }
    assert_redirected_to core_account_url(@core_account)
  end

  test "should destroy core_account" do
    assert_difference('Core::Account.count', -1) do
      delete core_account_url(@core_account)
    end

    assert_redirected_to core_accounts_url
  end
end
