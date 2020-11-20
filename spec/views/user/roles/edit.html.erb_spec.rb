require 'rails_helper'

RSpec.describe "user/roles/edit", type: :view do
  before(:each) do
    @user_role = assign(:user_role, User::Role.create!())
  end

  it "renders the edit user_role form" do
    render

    assert_select "form[action=?][method=?]", user_role_path(@user_role), "post" do
    end
  end
end
