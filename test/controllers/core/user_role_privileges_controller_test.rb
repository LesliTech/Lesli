require 'test_helper'

class Core::UserRolePrivilegesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_user_role_privilege = core_user_role_privileges(:one)
  end

  test "should get index" do
    get core_user_role_privileges_url
    assert_response :success
  end

  test "should get new" do
    get new_core_user_role_privilege_url
    assert_response :success
  end

  test "should create core_user_role_privilege" do
    assert_difference('Core::UserRolePrivilege.count') do
      post core_user_role_privileges_url, params: { core_user_role_privilege: {  } }
    end

    assert_redirected_to core_user_role_privilege_url(Core::UserRolePrivilege.last)
  end

  test "should show core_user_role_privilege" do
    get core_user_role_privilege_url(@core_user_role_privilege)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_user_role_privilege_url(@core_user_role_privilege)
    assert_response :success
  end

  test "should update core_user_role_privilege" do
    patch core_user_role_privilege_url(@core_user_role_privilege), params: { core_user_role_privilege: {  } }
    assert_redirected_to core_user_role_privilege_url(@core_user_role_privilege)
  end

  test "should destroy core_user_role_privilege" do
    assert_difference('Core::UserRolePrivilege.count', -1) do
      delete core_user_role_privilege_url(@core_user_role_privilege)
    end

    assert_redirected_to core_user_role_privileges_url
  end
end
