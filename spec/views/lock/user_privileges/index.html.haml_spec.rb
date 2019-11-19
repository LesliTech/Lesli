require 'rails_helper'

RSpec.describe "lock/user_privileges/index", type: :view do
  before(:each) do
    assign(:lock_user_privileges, [
      Lock::UserPrivilege.create!(),
      Lock::UserPrivilege.create!()
    ])
  end

  it "renders a list of lock/user_privileges" do
    render
  end
end
