require 'rails_helper'

RSpec.describe "user_activities/show", type: :view do
  before(:each) do
    @user_activity = assign(:user_activity, UserActivity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
