require 'rails_helper'

RSpec.describe "lock/role_privileges/show", type: :view do
  before(:each) do
    @lock_role_privilege = assign(:lock_role_privilege, Lock::RolePrivilege.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
