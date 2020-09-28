require 'rails_helper'

RSpec.describe "user/logs/show", type: :view do
  before(:each) do
    @user_log = assign(:user_log, User::Log.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
