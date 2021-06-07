require 'rails_helper'

RSpec.describe "account/privilege_group_actions/edit", type: :view do
  before(:each) do
    @account_privilege_group_action = assign(:account_privilege_group_action, Account::PrivilegeGroupAction.create!())
  end

  it "renders the edit account_privilege_group_action form" do
    render

    assert_select "form[action=?][method=?]", account_privilege_group_action_path(@account_privilege_group_action), "post" do
    end
  end
end
