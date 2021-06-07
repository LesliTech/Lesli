require 'rails_helper'

RSpec.describe "account/privilege_group_actions/show", type: :view do
  before(:each) do
    @account_privilege_group_action = assign(:account_privilege_group_action, Account::PrivilegeGroupAction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
