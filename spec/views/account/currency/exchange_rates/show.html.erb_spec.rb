require 'rails_helper'

RSpec.describe "account/currency/exchange_rates/show", type: :view do
  before(:each) do
    @account/currency_exchange_rate = assign(:account/currency_exchange_rate, Account::Currency::ExchangeRate.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
