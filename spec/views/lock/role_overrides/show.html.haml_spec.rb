require 'rails_helper'

RSpec.describe "lock/role_overrides/show", type: :view do
  before(:each) do
    @lock_role_override = assign(:lock_role_override, Lock::RoleOverride.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
