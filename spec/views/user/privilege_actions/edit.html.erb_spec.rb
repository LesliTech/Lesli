require 'rails_helper'

RSpec.describe "user/privilege_actions/edit", type: :view do
  before(:each) do
    @user_privilege_action = assign(:user_privilege_action, User::PrivilegeAction.create!())
  end

  it "renders the edit user_privilege_action form" do
    render

    assert_select "form[action=?][method=?]", user_privilege_action_path(@user_privilege_action), "post" do
    end
  end
end
