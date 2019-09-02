require "application_system_test_case"

class Company::LocationStatesTest < ApplicationSystemTestCase
  setup do
    @company_location_state = company_location_states(:one)
  end

  test "visiting the index" do
    visit company_location_states_url
    assert_selector "h1", text: "Company/Location States"
  end

  test "creating a Location state" do
    visit company_location_states_url
    click_on "New Company/Location State"

    click_on "Create Location state"

    assert_text "Location state was successfully created"
    click_on "Back"
  end

  test "updating a Location state" do
    visit company_location_states_url
    click_on "Edit", match: :first

    click_on "Update Location state"

    assert_text "Location state was successfully updated"
    click_on "Back"
  end

  test "destroying a Location state" do
    visit company_location_states_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Location state was successfully destroyed"
  end
end
