require 'rails_helper'

RSpec.describe "user/activities/show", type: :view do
  before(:each) do
    @user_activity = assign(:user_activity, User::Activity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
