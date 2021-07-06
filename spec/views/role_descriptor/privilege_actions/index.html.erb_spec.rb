require 'rails_helper'

RSpec.describe "role_descriptor/privilege_actions/index", type: :view do
  before(:each) do
    assign(:role_descriptor_privilege_actions, [
      RoleDescriptor::PrivilegeAction.create!(),
      RoleDescriptor::PrivilegeAction.create!()
    ])
  end

  it "renders a list of role_descriptor/privilege_actions" do
    render
  end
end
