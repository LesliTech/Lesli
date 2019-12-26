require 'rails_helper'

RSpec.describe "userrs/new", type: :view do
  before(:each) do
    assign(:userr, Userr.new())
  end

  it "renders new userr form" do
    render

    assert_select "form[action=?][method=?]", userrs_path, "post" do
    end
  end
end
