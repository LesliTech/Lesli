require 'rails_helper'

RSpec.describe "user/logs/index", type: :view do
  before(:each) do
    assign(:user_logs, [
      User::Log.create!(),
      User::Log.create!()
    ])
  end

  it "renders a list of user/logs" do
    render
  end
end
