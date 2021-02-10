require 'rails_helper'

RSpec.describe "account/currencies/new", type: :view do
  before(:each) do
    assign(:account_currency, Account::Currency.new())
  end

  it "renders new account_currency form" do
    render

    assert_select "form[action=?][method=?]", account_currencies_path, "post" do
    end
  end
end
