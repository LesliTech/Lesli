require 'rails_helper'

RSpec.describe "lock/user_role_privileges/new", type: :view do
  before(:each) do
    assign(:lock_user_role_privilege, Lock::UserRolePrivilege.new())
  end

  it "renders new lock_user_role_privilege form" do
    render

    assert_select "form[action=?][method=?]", lock_user_role_privileges_path, "post" do
    end
  end
end
