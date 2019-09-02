require "application_system_test_case"

class Company::LocationContinentsTest < ApplicationSystemTestCase
  setup do
    @company_location_continent = company_location_continents(:one)
  end

  test "visiting the index" do
    visit company_location_continents_url
    assert_selector "h1", text: "Company/Location Continents"
  end

  test "creating a Location continent" do
    visit company_location_continents_url
    click_on "New Company/Location Continent"

    click_on "Create Location continent"

    assert_text "Location continent was successfully created"
    click_on "Back"
  end

  test "updating a Location continent" do
    visit company_location_continents_url
    click_on "Edit", match: :first

    click_on "Update Location continent"

    assert_text "Location continent was successfully updated"
    click_on "Back"
  end

  test "destroying a Location continent" do
    visit company_location_continents_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Location continent was successfully destroyed"
  end
end
