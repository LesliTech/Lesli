require 'rails_helper'

RSpec.describe "user/settings/new", type: :view do
  before(:each) do
    assign(:user_setting, User::Setting.new())
  end

  it "renders new user_setting form" do
    render

    assert_select "form[action=?][method=?]", user_settings_path, "post" do
    end
  end
end
