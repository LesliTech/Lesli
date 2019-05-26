require "application_system_test_case"

class Core::UserRolesTest < ApplicationSystemTestCase
  setup do
    @core_user_role = core_user_roles(:one)
  end

  test "visiting the index" do
    visit core_user_roles_url
    assert_selector "h1", text: "Core/User Roles"
  end

  test "creating a User role" do
    visit core_user_roles_url
    click_on "New Core/User Role"

    click_on "Create User role"

    assert_text "User role was successfully created"
    click_on "Back"
  end

  test "updating a User role" do
    visit core_user_roles_url
    click_on "Edit", match: :first

    click_on "Update User role"

    assert_text "User role was successfully updated"
    click_on "Back"
  end

  test "destroying a User role" do
    visit core_user_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User role was successfully destroyed"
  end
end
