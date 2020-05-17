require 'rails_helper'

RSpec.describe "user_activities/new", type: :view do
  before(:each) do
    assign(:user_activity, UserActivity.new())
  end

  it "renders new user_activity form" do
    render

    assert_select "form[action=?][method=?]", user_activities_path, "post" do
    end
  end
end
