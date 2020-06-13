require 'rails_helper'

RSpec.describe "user/settings/index", type: :view do
  before(:each) do
    assign(:user_settings, [
      User::Setting.create!(),
      User::Setting.create!()
    ])
  end

  it "renders a list of user/settings" do
    render
  end
end
