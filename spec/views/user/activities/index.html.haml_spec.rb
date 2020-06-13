require 'rails_helper'

RSpec.describe "user/activities/index", type: :view do
  before(:each) do
    assign(:user_activities, [
      User::Activity.create!(),
      User::Activity.create!()
    ])
  end

  it "renders a list of user/activities" do
    render
  end
end
