require 'test_helper'

class Company::LocationContinentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_location_continent = company_location_continents(:one)
  end

  test "should get index" do
    get company_location_continents_url
    assert_response :success
  end

  test "should get new" do
    get new_company_location_continent_url
    assert_response :success
  end

  test "should create company_location_continent" do
    assert_difference('Company::LocationContinent.count') do
      post company_location_continents_url, params: { company_location_continent: {  } }
    end

    assert_redirected_to company_location_continent_url(Company::LocationContinent.last)
  end

  test "should show company_location_continent" do
    get company_location_continent_url(@company_location_continent)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_location_continent_url(@company_location_continent)
    assert_response :success
  end

  test "should update company_location_continent" do
    patch company_location_continent_url(@company_location_continent), params: { company_location_continent: {  } }
    assert_redirected_to company_location_continent_url(@company_location_continent)
  end

  test "should destroy company_location_continent" do
    assert_difference('Company::LocationContinent.count', -1) do
      delete company_location_continent_url(@company_location_continent)
    end

    assert_redirected_to company_location_continents_url
  end
end
