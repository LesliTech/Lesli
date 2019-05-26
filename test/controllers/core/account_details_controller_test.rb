require 'test_helper'

class Core::AccountDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_account_detail = core_account_details(:one)
  end

  test "should get index" do
    get core_account_details_url
    assert_response :success
  end

  test "should get new" do
    get new_core_account_detail_url
    assert_response :success
  end

  test "should create core_account_detail" do
    assert_difference('Core::AccountDetail.count') do
      post core_account_details_url, params: { core_account_detail: {  } }
    end

    assert_redirected_to core_account_detail_url(Core::AccountDetail.last)
  end

  test "should show core_account_detail" do
    get core_account_detail_url(@core_account_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_account_detail_url(@core_account_detail)
    assert_response :success
  end

  test "should update core_account_detail" do
    patch core_account_detail_url(@core_account_detail), params: { core_account_detail: {  } }
    assert_redirected_to core_account_detail_url(@core_account_detail)
  end

  test "should destroy core_account_detail" do
    assert_difference('Core::AccountDetail.count', -1) do
      delete core_account_detail_url(@core_account_detail)
    end

    assert_redirected_to core_account_details_url
  end
end
