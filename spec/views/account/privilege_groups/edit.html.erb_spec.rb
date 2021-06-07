require 'rails_helper'

RSpec.describe "account/privilege_groups/edit", type: :view do
  before(:each) do
    @account_privilege_group = assign(:account_privilege_group, Account::PrivilegeGroup.create!())
  end

  it "renders the edit account_privilege_group form" do
    render

    assert_select "form[action=?][method=?]", account_privilege_group_path(@account_privilege_group), "post" do
    end
  end
end
