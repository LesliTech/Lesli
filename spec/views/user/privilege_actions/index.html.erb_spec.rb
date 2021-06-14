require 'rails_helper'

RSpec.describe "user/privilege_actions/index", type: :view do
  before(:each) do
    assign(:user_privilege_actions, [
      User::PrivilegeAction.create!(),
      User::PrivilegeAction.create!()
    ])
  end

  it "renders a list of user/privilege_actions" do
    render
  end
end
