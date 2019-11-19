require 'rails_helper'

RSpec.describe "lock/user_role_privileges/show", type: :view do
  before(:each) do
    @lock_user_role_privilege = assign(:lock_user_role_privilege, Lock::UserRolePrivilege.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
