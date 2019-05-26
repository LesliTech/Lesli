require "application_system_test_case"

class Core::UserDetailsTest < ApplicationSystemTestCase
  setup do
    @core_user_detail = core_user_details(:one)
  end

  test "visiting the index" do
    visit core_user_details_url
    assert_selector "h1", text: "Core/User Details"
  end

  test "creating a User detail" do
    visit core_user_details_url
    click_on "New Core/User Detail"

    click_on "Create User detail"

    assert_text "User detail was successfully created"
    click_on "Back"
  end

  test "updating a User detail" do
    visit core_user_details_url
    click_on "Edit", match: :first

    click_on "Update User detail"

    assert_text "User detail was successfully updated"
    click_on "Back"
  end

  test "destroying a User detail" do
    visit core_user_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User detail was successfully destroyed"
  end
end
