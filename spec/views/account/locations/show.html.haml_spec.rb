require 'rails_helper'

RSpec.describe "account/locations/show", type: :view do
  before(:each) do
    @account_location = assign(:account_location, Account::Location.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
