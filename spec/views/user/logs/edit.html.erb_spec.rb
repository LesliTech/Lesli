require 'rails_helper'

RSpec.describe "user/logs/edit", type: :view do
  before(:each) do
    @user_log = assign(:user_log, User::Log.create!())
  end

  it "renders the edit user_log form" do
    render

    assert_select "form[action=?][method=?]", user_log_path(@user_log), "post" do
    end
  end
end
