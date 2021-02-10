require 'rails_helper'

RSpec.describe "account/currency/exchange_rates/edit", type: :view do
  before(:each) do
    @account/currency_exchange_rate = assign(:account/currency_exchange_rate, Account::Currency::ExchangeRate.create!())
  end

  it "renders the edit account/currency_exchange_rate form" do
    render

    assert_select "form[action=?][method=?]", account/currency_exchange_rate_path(@account/currency_exchange_rate), "post" do
    end
  end
end
