require 'rails_helper'

RSpec.describe "user/roles/new", type: :view do
  before(:each) do
    assign(:user_role, User::Role.new())
  end

  it "renders new user_role form" do
    render

    assert_select "form[action=?][method=?]", user_roles_path, "post" do
    end
  end
end
