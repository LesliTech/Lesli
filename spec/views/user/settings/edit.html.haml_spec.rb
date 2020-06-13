require 'rails_helper'

RSpec.describe "user/settings/edit", type: :view do
  before(:each) do
    @user_setting = assign(:user_setting, User::Setting.create!())
  end

  it "renders the edit user_setting form" do
    render

    assert_select "form[action=?][method=?]", user_setting_path(@user_setting), "post" do
    end
  end
end
