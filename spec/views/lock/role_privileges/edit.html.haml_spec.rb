require 'rails_helper'

RSpec.describe "lock/role_privileges/edit", type: :view do
  before(:each) do
    @lock_role_privilege = assign(:lock_role_privilege, Lock::RolePrivilege.create!())
  end

  it "renders the edit lock_role_privilege form" do
    render

    assert_select "form[action=?][method=?]", lock_role_privilege_path(@lock_role_privilege), "post" do
    end
  end
end
