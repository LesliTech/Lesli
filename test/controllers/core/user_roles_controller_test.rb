require 'test_helper'

class Core::UserRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_user_role = core_user_roles(:one)
  end

  test "should get index" do
    get core_user_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_core_user_role_url
    assert_response :success
  end

  test "should create core_user_role" do
    assert_difference('Core::UserRole.count') do
      post core_user_roles_url, params: { core_user_role: {  } }
    end

    assert_redirected_to core_user_role_url(Core::UserRole.last)
  end

  test "should show core_user_role" do
    get core_user_role_url(@core_user_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_user_role_url(@core_user_role)
    assert_response :success
  end

  test "should update core_user_role" do
    patch core_user_role_url(@core_user_role), params: { core_user_role: {  } }
    assert_redirected_to core_user_role_url(@core_user_role)
  end

  test "should destroy core_user_role" do
    assert_difference('Core::UserRole.count', -1) do
      delete core_user_role_url(@core_user_role)
    end

    assert_redirected_to core_user_roles_url
  end
end
