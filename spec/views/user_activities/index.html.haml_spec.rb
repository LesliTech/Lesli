require 'rails_helper'

RSpec.describe "user_activities/index", type: :view do
  before(:each) do
    assign(:user_activities, [
      UserActivity.create!(),
      UserActivity.create!()
    ])
  end

  it "renders a list of user_activities" do
    render
  end
end
