require 'rails_helper'

RSpec.describe "role_descriptor/privilege_actions/edit", type: :view do
  before(:each) do
    @role_descriptor_privilege_action = assign(:role_descriptor_privilege_action, RoleDescriptor::PrivilegeAction.create!())
  end

  it "renders the edit role_descriptor_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_privilege_action_path(@role_descriptor_privilege_action), "post" do
    end
  end
end
