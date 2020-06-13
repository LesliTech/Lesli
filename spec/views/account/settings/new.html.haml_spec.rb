require 'rails_helper'

RSpec.describe "account/settings/new", type: :view do
  before(:each) do
    assign(:account_setting, Account::Setting.new())
  end

  it "renders new account_setting form" do
    render

    assert_select "form[action=?][method=?]", account_settings_path, "post" do
    end
  end
end
