require 'rails_helper'

RSpec.describe "lock/role_privileges/index", type: :view do
  before(:each) do
    assign(:lock_role_privileges, [
      Lock::RolePrivilege.create!(),
      Lock::RolePrivilege.create!()
    ])
  end

  it "renders a list of lock/role_privileges" do
    render
  end
end
