require 'rails_helper'

RSpec.describe "account/settings/show", type: :view do
  before(:each) do
    @account_setting = assign(:account_setting, Account::Setting.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
