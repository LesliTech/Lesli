require "application_system_test_case"

class AccountPlansTest < ApplicationSystemTestCase
  setup do
    @account_plan = account_plans(:one)
  end

  test "visiting the index" do
    visit account_plans_url
    assert_selector "h1", text: "Account Plans"
  end

  test "creating a Account plan" do
    visit account_plans_url
    click_on "New Account Plan"

    click_on "Create Account plan"

    assert_text "Account plan was successfully created"
    click_on "Back"
  end

  test "updating a Account plan" do
    visit account_plans_url
    click_on "Edit", match: :first

    click_on "Update Account plan"

    assert_text "Account plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Account plan" do
    visit account_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account plan was successfully destroyed"
  end
end
