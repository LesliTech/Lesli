require "application_system_test_case"

class Lesli::DashboardsTest < ApplicationSystemTestCase
  setup do
    @lesli_dashboard = lesli_dashboards(:one)
  end

  test "visiting the index" do
    visit lesli_dashboards_url
    assert_selector "h1", text: "Lesli/Dashboards"
  end

  test "creating a Dashboard" do
    visit lesli_dashboards_url
    click_on "New Lesli/Dashboard"

    click_on "Create Dashboard"

    assert_text "Dashboard was successfully created"
    click_on "Back"
  end

  test "updating a Dashboard" do
    visit lesli_dashboards_url
    click_on "Edit", match: :first

    click_on "Update Dashboard"

    assert_text "Dashboard was successfully updated"
    click_on "Back"
  end

  test "destroying a Dashboard" do
    visit lesli_dashboards_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dashboard was successfully destroyed"
  end
end
