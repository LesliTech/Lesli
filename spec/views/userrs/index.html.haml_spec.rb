require 'rails_helper'

RSpec.describe "userrs/index", type: :view do
  before(:each) do
    assign(:userrs, [
      Userr.create!(),
      Userr.create!()
    ])
  end

  it "renders a list of userrs" do
    render
  end
end
