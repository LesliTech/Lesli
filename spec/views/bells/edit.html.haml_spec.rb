require 'rails_helper'

RSpec.describe "bells/edit", type: :view do
  before(:each) do
    @bell = assign(:bell, Bell.create!())
  end

  it "renders the edit bell form" do
    render

    assert_select "form[action=?][method=?]", bell_path(@bell), "post" do
    end
  end
end
