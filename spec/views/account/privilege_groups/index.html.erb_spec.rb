require 'rails_helper'

RSpec.describe "account/privilege_groups/index", type: :view do
  before(:each) do
    assign(:account_privilege_groups, [
      Account::PrivilegeGroup.create!(),
      Account::PrivilegeGroup.create!()
    ])
  end

  it "renders a list of account/privilege_groups" do
    render
  end
end
