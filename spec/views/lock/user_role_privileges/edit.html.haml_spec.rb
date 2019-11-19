require 'rails_helper'

RSpec.describe "lock/user_role_privileges/edit", type: :view do
  before(:each) do
    @lock_user_role_privilege = assign(:lock_user_role_privilege, Lock::UserRolePrivilege.create!())
  end

  it "renders the edit lock_user_role_privilege form" do
    render

    assert_select "form[action=?][method=?]", lock_user_role_privilege_path(@lock_user_role_privilege), "post" do
    end
  end
end
