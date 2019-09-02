require 'test_helper'

class Company::RolePrivilegesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_role_privilege = company_role_privileges(:one)
  end

  test "should get index" do
    get company_role_privileges_url
    assert_response :success
  end

  test "should get new" do
    get new_company_role_privilege_url
    assert_response :success
  end

  test "should create company_role_privilege" do
    assert_difference('Company::RolePrivilege.count') do
      post company_role_privileges_url, params: { company_role_privilege: {  } }
    end

    assert_redirected_to company_role_privilege_url(Company::RolePrivilege.last)
  end

  test "should show company_role_privilege" do
    get company_role_privilege_url(@company_role_privilege)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_role_privilege_url(@company_role_privilege)
    assert_response :success
  end

  test "should update company_role_privilege" do
    patch company_role_privilege_url(@company_role_privilege), params: { company_role_privilege: {  } }
    assert_redirected_to company_role_privilege_url(@company_role_privilege)
  end

  test "should destroy company_role_privilege" do
    assert_difference('Company::RolePrivilege.count', -1) do
      delete company_role_privilege_url(@company_role_privilege)
    end

    assert_redirected_to company_role_privileges_url
  end
end
