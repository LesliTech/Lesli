require 'rails_helper'

RSpec.describe "account/privilege_group_actions/new", type: :view do
  before(:each) do
    assign(:account_privilege_group_action, Account::PrivilegeGroupAction.new())
  end

  it "renders new account_privilege_group_action form" do
    render

    assert_select "form[action=?][method=?]", account_privilege_group_actions_path, "post" do
    end
  end
end
