require 'rails_helper'

RSpec.describe "lock/role_privileges/new", type: :view do
  before(:each) do
    assign(:lock_role_privilege, Lock::RolePrivilege.new())
  end

  it "renders new lock_role_privilege form" do
    render

    assert_select "form[action=?][method=?]", lock_role_privileges_path, "post" do
    end
  end
end
