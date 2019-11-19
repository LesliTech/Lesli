require 'rails_helper'

RSpec.describe "lock/user_privileges/show", type: :view do
  before(:each) do
    @lock_user_privilege = assign(:lock_user_privilege, Lock::UserPrivilege.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
