require "application_system_test_case"

class Core::AccountPlansTest < ApplicationSystemTestCase
  setup do
    @core_account_plan = core_account_plans(:one)
  end

  test "visiting the index" do
    visit core_account_plans_url
    assert_selector "h1", text: "Core/Account Plans"
  end

  test "creating a Account plan" do
    visit core_account_plans_url
    click_on "New Core/Account Plan"

    click_on "Create Account plan"

    assert_text "Account plan was successfully created"
    click_on "Back"
  end

  test "updating a Account plan" do
    visit core_account_plans_url
    click_on "Edit", match: :first

    click_on "Update Account plan"

    assert_text "Account plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Account plan" do
    visit core_account_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account plan was successfully destroyed"
  end
end
