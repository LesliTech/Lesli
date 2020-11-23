require 'rails_helper'

RSpec.describe "user/roles/index", type: :view do
  before(:each) do
    assign(:user_roles, [
      User::Role.create!(),
      User::Role.create!()
    ])
  end

  it "renders a list of user/roles" do
    render
  end
end
