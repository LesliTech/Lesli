require "application_system_test_case"

class Company::LocationCitiesTest < ApplicationSystemTestCase
  setup do
    @company_location_city = company_location_cities(:one)
  end

  test "visiting the index" do
    visit company_location_cities_url
    assert_selector "h1", text: "Company/Location Cities"
  end

  test "creating a Location city" do
    visit company_location_cities_url
    click_on "New Company/Location City"

    click_on "Create Location city"

    assert_text "Location city was successfully created"
    click_on "Back"
  end

  test "updating a Location city" do
    visit company_location_cities_url
    click_on "Edit", match: :first

    click_on "Update Location city"

    assert_text "Location city was successfully updated"
    click_on "Back"
  end

  test "destroying a Location city" do
    visit company_location_cities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Location city was successfully destroyed"
  end
end
