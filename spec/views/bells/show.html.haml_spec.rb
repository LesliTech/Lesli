require 'rails_helper'

RSpec.describe "bells/show", type: :view do
  before(:each) do
    @bell = assign(:bell, Bell.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
