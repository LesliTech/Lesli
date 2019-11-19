require 'rails_helper'

RSpec.describe "bells/new", type: :view do
  before(:each) do
    assign(:bell, Bell.new())
  end

  it "renders new bell form" do
    render

    assert_select "form[action=?][method=?]", bells_path, "post" do
    end
  end
end
