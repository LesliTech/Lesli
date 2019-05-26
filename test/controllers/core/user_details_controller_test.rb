require 'test_helper'

class Core::UserDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_user_detail = core_user_details(:one)
  end

  test "should get index" do
    get core_user_details_url
    assert_response :success
  end

  test "should get new" do
    get new_core_user_detail_url
    assert_response :success
  end

  test "should create core_user_detail" do
    assert_difference('Core::UserDetail.count') do
      post core_user_details_url, params: { core_user_detail: {  } }
    end

    assert_redirected_to core_user_detail_url(Core::UserDetail.last)
  end

  test "should show core_user_detail" do
    get core_user_detail_url(@core_user_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_user_detail_url(@core_user_detail)
    assert_response :success
  end

  test "should update core_user_detail" do
    patch core_user_detail_url(@core_user_detail), params: { core_user_detail: {  } }
    assert_redirected_to core_user_detail_url(@core_user_detail)
  end

  test "should destroy core_user_detail" do
    assert_difference('Core::UserDetail.count', -1) do
      delete core_user_detail_url(@core_user_detail)
    end

    assert_redirected_to core_user_details_url
  end
end
