require 'rails_helper'

RSpec.describe "bells/index", type: :view do
  before(:each) do
    assign(:bells, [
      Bell.create!(),
      Bell.create!()
    ])
  end

  it "renders a list of bells" do
    render
  end
end
