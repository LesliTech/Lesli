require 'rails_helper'

RSpec.describe "account/currencies/show", type: :view do
  before(:each) do
    @account_currency = assign(:account_currency, Account::Currency.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
