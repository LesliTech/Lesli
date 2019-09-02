require "application_system_test_case"

class Company::RolePrivilegesTest < ApplicationSystemTestCase
  setup do
    @company_role_privilege = company_role_privileges(:one)
  end

  test "visiting the index" do
    visit company_role_privileges_url
    assert_selector "h1", text: "Company/Role Privileges"
  end

  test "creating a Role privilege" do
    visit company_role_privileges_url
    click_on "New Company/Role Privilege"

    click_on "Create Role privilege"

    assert_text "Role privilege was successfully created"
    click_on "Back"
  end

  test "updating a Role privilege" do
    visit company_role_privileges_url
    click_on "Edit", match: :first

    click_on "Update Role privilege"

    assert_text "Role privilege was successfully updated"
    click_on "Back"
  end

  test "destroying a Role privilege" do
    visit company_role_privileges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Role privilege was successfully destroyed"
  end
end
