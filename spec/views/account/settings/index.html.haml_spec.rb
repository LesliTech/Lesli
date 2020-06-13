require 'rails_helper'

RSpec.describe "account/settings/index", type: :view do
  before(:each) do
    assign(:account_settings, [
      Account::Setting.create!(),
      Account::Setting.create!()
    ])
  end

  it "renders a list of account/settings" do
    render
  end
end
