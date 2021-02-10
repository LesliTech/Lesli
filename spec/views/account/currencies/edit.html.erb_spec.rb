require 'rails_helper'

RSpec.describe "account/currencies/edit", type: :view do
  before(:each) do
    @account_currency = assign(:account_currency, Account::Currency.create!())
  end

  it "renders the edit account_currency form" do
    render

    assert_select "form[action=?][method=?]", account_currency_path(@account_currency), "post" do
    end
  end
end
