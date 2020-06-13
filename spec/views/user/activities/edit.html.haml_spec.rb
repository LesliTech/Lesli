require 'rails_helper'

RSpec.describe "user/activities/edit", type: :view do
  before(:each) do
    @user_activity = assign(:user_activity, User::Activity.create!())
  end

  it "renders the edit user_activity form" do
    render

    assert_select "form[action=?][method=?]", user_activity_path(@user_activity), "post" do
    end
  end
end
