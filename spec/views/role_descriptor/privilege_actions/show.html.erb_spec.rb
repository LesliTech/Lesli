require 'rails_helper'

RSpec.describe "role_descriptor/privilege_actions/show", type: :view do
  before(:each) do
    @role_descriptor_privilege_action = assign(:role_descriptor_privilege_action, RoleDescriptor::PrivilegeAction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
