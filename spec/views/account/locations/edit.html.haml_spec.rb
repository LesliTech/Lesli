require 'rails_helper'

RSpec.describe "account/locations/edit", type: :view do
  before(:each) do
    @account_location = assign(:account_location, Account::Location.create!())
  end

  it "renders the edit account_location form" do
    render

    assert_select "form[action=?][method=?]", account_location_path(@account_location), "post" do
    end
  end
end
