require 'rails_helper'

RSpec.describe "lock/user_role_privileges/index", type: :view do
  before(:each) do
    assign(:lock_user_role_privileges, [
      Lock::UserRolePrivilege.create!(),
      Lock::UserRolePrivilege.create!()
    ])
  end

  it "renders a list of lock/user_role_privileges" do
    render
  end
end
