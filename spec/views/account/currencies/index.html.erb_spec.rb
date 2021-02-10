require 'rails_helper'

RSpec.describe "account/currencies/index", type: :view do
  before(:each) do
    assign(:account_currencies, [
      Account::Currency.create!(),
      Account::Currency.create!()
    ])
  end

  it "renders a list of account/currencies" do
    render
  end
end
