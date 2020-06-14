require 'rails_helper'

RSpec.describe "user/details/edit", type: :view do
  before(:each) do
    @user_detail = assign(:user_detail, User::Detail.create!())
  end

  it "renders the edit user_detail form" do
    render

    assert_select "form[action=?][method=?]", user_detail_path(@user_detail), "post" do
    end
  end
end
