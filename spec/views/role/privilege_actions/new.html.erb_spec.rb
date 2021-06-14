require 'rails_helper'

RSpec.describe "role/privilege_actions/new", type: :view do
  before(:each) do
    assign(:role_privilege_action, Role::PrivilegeAction.new())
  end

  it "renders new role_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", role_privilege_actions_path, "post" do
    end
  end
end
