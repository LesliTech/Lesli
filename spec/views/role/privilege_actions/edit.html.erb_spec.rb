require 'rails_helper'

RSpec.describe "role/privilege_actions/edit", type: :view do
  before(:each) do
    @role_privilege_action = assign(:role_privilege_action, Role::PrivilegeAction.create!())
  end

  it "renders the edit role_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", role_privilege_action_path(@role_privilege_action), "post" do
    end
  end
end
