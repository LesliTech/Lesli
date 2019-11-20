require 'rails_helper'

RSpec.describe "lock/role_overrides/new", type: :view do
  before(:each) do
    assign(:lock_role_override, Lock::RoleOverride.new())
  end

  it "renders new lock_role_override form" do
    render

    assert_select "form[action=?][method=?]", lock_role_overrides_path, "post" do
    end
  end
end
