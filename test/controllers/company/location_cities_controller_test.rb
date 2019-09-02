require 'test_helper'

class Company::LocationCitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_location_city = company_location_cities(:one)
  end

  test "should get index" do
    get company_location_cities_url
    assert_response :success
  end

  test "should get new" do
    get new_company_location_city_url
    assert_response :success
  end

  test "should create company_location_city" do
    assert_difference('Company::LocationCity.count') do
      post company_location_cities_url, params: { company_location_city: {  } }
    end

    assert_redirected_to company_location_city_url(Company::LocationCity.last)
  end

  test "should show company_location_city" do
    get company_location_city_url(@company_location_city)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_location_city_url(@company_location_city)
    assert_response :success
  end

  test "should update company_location_city" do
    patch company_location_city_url(@company_location_city), params: { company_location_city: {  } }
    assert_redirected_to company_location_city_url(@company_location_city)
  end

  test "should destroy company_location_city" do
    assert_difference('Company::LocationCity.count', -1) do
      delete company_location_city_url(@company_location_city)
    end

    assert_redirected_to company_location_cities_url
  end
end
