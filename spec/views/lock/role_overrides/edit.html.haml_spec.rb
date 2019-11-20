require 'rails_helper'

RSpec.describe "lock/role_overrides/edit", type: :view do
  before(:each) do
    @lock_role_override = assign(:lock_role_override, Lock::RoleOverride.create!())
  end

  it "renders the edit lock_role_override form" do
    render

    assert_select "form[action=?][method=?]", lock_role_override_path(@lock_role_override), "post" do
    end
  end
end
