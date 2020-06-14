require 'rails_helper'

RSpec.describe "account/settings/edit", type: :view do
  before(:each) do
    @account_setting = assign(:account_setting, Account::Setting.create!())
  end

  it "renders the edit account_setting form" do
    render

    assert_select "form[action=?][method=?]", account_setting_path(@account_setting), "post" do
    end
  end
end
