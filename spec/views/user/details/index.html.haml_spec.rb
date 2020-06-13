require 'rails_helper'

RSpec.describe "user/details/index", type: :view do
  before(:each) do
    assign(:user_details, [
      User::Detail.create!(),
      User::Detail.create!()
    ])
  end

  it "renders a list of user/details" do
    render
  end
end
