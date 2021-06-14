require 'rails_helper'

RSpec.describe "user/privilege_actions/show", type: :view do
  before(:each) do
    @user_privilege_action = assign(:user_privilege_action, User::PrivilegeAction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
