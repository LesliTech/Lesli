require 'rails_helper'

RSpec.describe "lock/user_roles/index", type: :view do
  before(:each) do
    assign(:lock_user_roles, [
      Lock::UserRole.create!(),
      Lock::UserRole.create!()
    ])
  end

  it "renders a list of lock/user_roles" do
    render
  end
end
