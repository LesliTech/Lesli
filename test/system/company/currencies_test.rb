require "application_system_test_case"

class Company::CurrenciesTest < ApplicationSystemTestCase
  setup do
    @company_currency = company_currencies(:one)
  end

  test "visiting the index" do
    visit company_currencies_url
    assert_selector "h1", text: "Company/Currencies"
  end

  test "creating a Currency" do
    visit company_currencies_url
    click_on "New Company/Currency"

    click_on "Create Currency"

    assert_text "Currency was successfully created"
    click_on "Back"
  end

  test "updating a Currency" do
    visit company_currencies_url
    click_on "Edit", match: :first

    click_on "Update Currency"

    assert_text "Currency was successfully updated"
    click_on "Back"
  end

  test "destroying a Currency" do
    visit company_currencies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Currency was successfully destroyed"
  end
end
