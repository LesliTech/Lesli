require 'rails_helper'

RSpec.describe "userrs/show", type: :view do
  before(:each) do
    @userr = assign(:userr, Userr.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
