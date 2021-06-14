require 'rails_helper'

RSpec.describe "role/privilege_actions/show", type: :view do
  before(:each) do
    @role_privilege_action = assign(:role_privilege_action, Role::PrivilegeAction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
