require 'rails_helper'

RSpec.describe "role/privilege_actions/index", type: :view do
  before(:each) do
    assign(:role_privilege_actions, [
      Role::PrivilegeAction.create!(),
      Role::PrivilegeAction.create!()
    ])
  end

  it "renders a list of role/privilege_actions" do
    render
  end
end
