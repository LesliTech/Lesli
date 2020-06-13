require 'rails_helper'

RSpec.describe "user/details/new", type: :view do
  before(:each) do
    assign(:user_detail, User::Detail.new())
  end

  it "renders new user_detail form" do
    render

    assert_select "form[action=?][method=?]", user_details_path, "post" do
    end
  end
end
