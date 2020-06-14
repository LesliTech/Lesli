require 'rails_helper'

RSpec.describe "user/settings/show", type: :view do
  before(:each) do
    @user_setting = assign(:user_setting, User::Setting.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
