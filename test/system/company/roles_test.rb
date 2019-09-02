require "application_system_test_case"

class Company::RolesTest < ApplicationSystemTestCase
  setup do
    @company_role = company_roles(:one)
  end

  test "visiting the index" do
    visit company_roles_url
    assert_selector "h1", text: "Company/Roles"
  end

  test "creating a Role" do
    visit company_roles_url
    click_on "New Company/Role"

    click_on "Create Role"

    assert_text "Role was successfully created"
    click_on "Back"
  end

  test "updating a Role" do
    visit company_roles_url
    click_on "Edit", match: :first

    click_on "Update Role"

    assert_text "Role was successfully updated"
    click_on "Back"
  end

  test "destroying a Role" do
    visit company_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Role was successfully destroyed"
  end
end
