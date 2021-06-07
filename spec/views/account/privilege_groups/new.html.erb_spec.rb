require 'rails_helper'

RSpec.describe "account/privilege_groups/new", type: :view do
  before(:each) do
    assign(:account_privilege_group, Account::PrivilegeGroup.new())
  end

  it "renders new account_privilege_group form" do
    render

    assert_select "form[action=?][method=?]", account_privilege_groups_path, "post" do
    end
  end
end
