require 'rails_helper'

RSpec.describe "account/privilege_groups/show", type: :view do
  before(:each) do
    @account_privilege_group = assign(:account_privilege_group, Account::PrivilegeGroup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
