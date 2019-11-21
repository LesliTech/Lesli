require 'rails_helper'

RSpec.describe "lock/role_overrides/index", type: :view do
  before(:each) do
    assign(:lock_role_overrides, [
      Lock::RoleOverride.create!(),
      Lock::RoleOverride.create!()
    ])
  end

  it "renders a list of lock/role_overrides" do
    render
  end
end
