require "application_system_test_case"

class Core::AccountDetailsTest < ApplicationSystemTestCase
  setup do
    @core_account_detail = core_account_details(:one)
  end

  test "visiting the index" do
    visit core_account_details_url
    assert_selector "h1", text: "Core/Account Details"
  end

  test "creating a Account detail" do
    visit core_account_details_url
    click_on "New Core/Account Detail"

    click_on "Create Account detail"

    assert_text "Account detail was successfully created"
    click_on "Back"
  end

  test "updating a Account detail" do
    visit core_account_details_url
    click_on "Edit", match: :first

    click_on "Update Account detail"

    assert_text "Account detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Account detail" do
    visit core_account_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account detail was successfully destroyed"
  end
end
