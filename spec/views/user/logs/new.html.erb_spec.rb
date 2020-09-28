require 'rails_helper'

RSpec.describe "user/logs/new", type: :view do
  before(:each) do
    assign(:user_log, User::Log.new())
  end

  it "renders new user_log form" do
    render

    assert_select "form[action=?][method=?]", user_logs_path, "post" do
    end
  end
end
