require 'rails_helper'

RSpec.describe "account/privilege_group_actions/index", type: :view do
  before(:each) do
    assign(:account_privilege_group_actions, [
      Account::PrivilegeGroupAction.create!(),
      Account::PrivilegeGroupAction.create!()
    ])
  end

  it "renders a list of account/privilege_group_actions" do
    render
  end
end
