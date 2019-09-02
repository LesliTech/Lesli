require 'test_helper'

class Company::LocationStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_location_state = company_location_states(:one)
  end

  test "should get index" do
    get company_location_states_url
    assert_response :success
  end

  test "should get new" do
    get new_company_location_state_url
    assert_response :success
  end

  test "should create company_location_state" do
    assert_difference('Company::LocationState.count') do
      post company_location_states_url, params: { company_location_state: {  } }
    end

    assert_redirected_to company_location_state_url(Company::LocationState.last)
  end

  test "should show company_location_state" do
    get company_location_state_url(@company_location_state)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_location_state_url(@company_location_state)
    assert_response :success
  end

  test "should update company_location_state" do
    patch company_location_state_url(@company_location_state), params: { company_location_state: {  } }
    assert_redirected_to company_location_state_url(@company_location_state)
  end

  test "should destroy company_location_state" do
    assert_difference('Company::LocationState.count', -1) do
      delete company_location_state_url(@company_location_state)
    end

    assert_redirected_to company_location_states_url
  end
end
