require 'rails_helper'

RSpec.describe "user/details/show", type: :view do
  before(:each) do
    @user_detail = assign(:user_detail, User::Detail.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
