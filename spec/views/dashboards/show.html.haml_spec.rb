require 'rails_helper'

RSpec.describe "dashboards/show", type: :view do
  before(:each) do
    @dashboard = assign(:dashboard, Dashboard.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
