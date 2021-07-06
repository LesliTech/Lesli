require 'rails_helper'

RSpec.describe "role_descriptor/privilege_actions/new", type: :view do
  before(:each) do
    assign(:role_descriptor_privilege_action, RoleDescriptor::PrivilegeAction.new())
  end

  it "renders new role_descriptor_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_privilege_actions_path, "post" do
    end
  end
end
