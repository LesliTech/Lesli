require 'rails_helper'

RSpec.describe "user/privilege_actions/new", type: :view do
  before(:each) do
    assign(:user_privilege_action, User::PrivilegeAction.new())
  end

  it "renders new user_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", user_privilege_actions_path, "post" do
    end
  end
end
