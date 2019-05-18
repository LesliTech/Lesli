require "application_system_test_case"

class Website::PagesTest < ApplicationSystemTestCase
  setup do
    @website_page = website_pages(:one)
  end

  test "visiting the index" do
    visit website_pages_url
    assert_selector "h1", text: "Website/Pages"
  end

  test "creating a Page" do
    visit website_pages_url
    click_on "New Website/Page"

    click_on "Create Page"

    assert_text "Page was successfully created"
    click_on "Back"
  end

  test "updating a Page" do
    visit website_pages_url
    click_on "Edit", match: :first

    click_on "Update Page"

    assert_text "Page was successfully updated"
    click_on "Back"
  end

  test "destroying a Page" do
    visit website_pages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Page was successfully destroyed"
  end
end
