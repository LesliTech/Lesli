require 'test_helper'

class Company::CurrenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_currency = company_currencies(:one)
  end

  test "should get index" do
    get company_currencies_url
    assert_response :success
  end

  test "should get new" do
    get new_company_currency_url
    assert_response :success
  end

  test "should create company_currency" do
    assert_difference('Company::Currency.count') do
      post company_currencies_url, params: { company_currency: {  } }
    end

    assert_redirected_to company_currency_url(Company::Currency.last)
  end

  test "should show company_currency" do
    get company_currency_url(@company_currency)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_currency_url(@company_currency)
    assert_response :success
  end

  test "should update company_currency" do
    patch company_currency_url(@company_currency), params: { company_currency: {  } }
    assert_redirected_to company_currency_url(@company_currency)
  end

  test "should destroy company_currency" do
    assert_difference('Company::Currency.count', -1) do
      delete company_currency_url(@company_currency)
    end

    assert_redirected_to company_currencies_url
  end
end
