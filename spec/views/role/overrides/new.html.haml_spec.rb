require 'rails_helper'

RSpec.describe "role/overrides/new", type: :view do
  before(:each) do
    assign(:role_override, Role::Override.new())
  end

  it "renders new role_override form" do
    render

    assert_select "form[action=?][method=?]", role_overrides_path, "post" do
    end
  end
end
