require 'test_helper'

class Company::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_role = company_roles(:one)
  end

  test "should get index" do
    get company_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_company_role_url
    assert_response :success
  end

  test "should create company_role" do
    assert_difference('Company::Role.count') do
      post company_roles_url, params: { company_role: {  } }
    end

    assert_redirected_to company_role_url(Company::Role.last)
  end

  test "should show company_role" do
    get company_role_url(@company_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_role_url(@company_role)
    assert_response :success
  end

  test "should update company_role" do
    patch company_role_url(@company_role), params: { company_role: {  } }
    assert_redirected_to company_role_url(@company_role)
  end

  test "should destroy company_role" do
    assert_difference('Company::Role.count', -1) do
      delete company_role_url(@company_role)
    end

    assert_redirected_to company_roles_url
  end
end
