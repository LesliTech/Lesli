require 'rails_helper'

RSpec.describe "account/locations/new", type: :view do
  before(:each) do
    assign(:account_location, Account::Location.new())
  end

  it "renders new account_location form" do
    render

    assert_select "form[action=?][method=?]", account_locations_path, "post" do
    end
  end
end
