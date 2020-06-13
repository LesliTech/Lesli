require 'rails_helper'

RSpec.describe "role/overrides/edit", type: :view do
  before(:each) do
    @role_override = assign(:role_override, Role::Override.create!())
  end

  it "renders the edit role_override form" do
    render

    assert_select "form[action=?][method=?]", role_override_path(@role_override), "post" do
    end
  end
end
