require "application_system_test_case"

class Core::UserRolePrivilegesTest < ApplicationSystemTestCase
  setup do
    @core_user_role_privilege = core_user_role_privileges(:one)
  end

  test "visiting the index" do
    visit core_user_role_privileges_url
    assert_selector "h1", text: "Core/User Role Privileges"
  end

  test "creating a User role privilege" do
    visit core_user_role_privileges_url
    click_on "New Core/User Role Privilege"

    click_on "Create User role privilege"

    assert_text "User role privilege was successfully created"
    click_on "Back"
  end

  test "updating a User role privilege" do
    visit core_user_role_privileges_url
    click_on "Edit", match: :first

    click_on "Update User role privilege"

    assert_text "User role privilege was successfully updated"
    click_on "Back"
  end

  test "destroying a User role privilege" do
    visit core_user_role_privileges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User role privilege was successfully destroyed"
  end
end
