require 'test_helper'

class Company::LocationCountriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_location_country = company_location_countries(:one)
  end

  test "should get index" do
    get company_location_countries_url
    assert_response :success
  end

  test "should get new" do
    get new_company_location_country_url
    assert_response :success
  end

  test "should create company_location_country" do
    assert_difference('Company::LocationCountry.count') do
      post company_location_countries_url, params: { company_location_country: {  } }
    end

    assert_redirected_to company_location_country_url(Company::LocationCountry.last)
  end

  test "should show company_location_country" do
    get company_location_country_url(@company_location_country)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_location_country_url(@company_location_country)
    assert_response :success
  end

  test "should update company_location_country" do
    patch company_location_country_url(@company_location_country), params: { company_location_country: {  } }
    assert_redirected_to company_location_country_url(@company_location_country)
  end

  test "should destroy company_location_country" do
    assert_difference('Company::LocationCountry.count', -1) do
      delete company_location_country_url(@company_location_country)
    end

    assert_redirected_to company_location_countries_url
  end
end
