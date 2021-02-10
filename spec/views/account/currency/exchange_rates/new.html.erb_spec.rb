require 'rails_helper'

RSpec.describe "account/currency/exchange_rates/new", type: :view do
  before(:each) do
    assign(:account/currency_exchange_rate, Account::Currency::ExchangeRate.new())
  end

  it "renders new account/currency_exchange_rate form" do
    render

    assert_select "form[action=?][method=?]", account_currency_exchange_rates_path, "post" do
    end
  end
end
