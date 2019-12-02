require 'rails_helper'

RSpec.describe "userrs/edit", type: :view do
  before(:each) do
    @userr = assign(:userr, Userr.create!())
  end

  it "renders the edit userr form" do
    render

    assert_select "form[action=?][method=?]", userr_path(@userr), "post" do
    end
  end
end
