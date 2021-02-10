require 'rails_helper'

RSpec.describe "account/currency/exchange_rates/index", type: :view do
  before(:each) do
    assign(:account_currency_exchange_rates, [
      Account::Currency::ExchangeRate.create!(),
      Account::Currency::ExchangeRate.create!()
    ])
  end

  it "renders a list of account/currency/exchange_rates" do
    render
  end
end
