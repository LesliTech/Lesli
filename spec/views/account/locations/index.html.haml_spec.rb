require 'rails_helper'

RSpec.describe "account/locations/index", type: :view do
  before(:each) do
    assign(:account_locations, [
      Account::Location.create!(),
      Account::Location.create!()
    ])
  end

  it "renders a list of account/locations" do
    render
  end
end
