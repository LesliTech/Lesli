require 'rails_helper'

RSpec.describe "dashboards/index", type: :view do
  before(:each) do
    assign(:dashboards, [
      Dashboard.create!(),
      Dashboard.create!()
    ])
  end

  it "renders a list of dashboards" do
    render
  end
end
