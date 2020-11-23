require 'rails_helper'

RSpec.describe "user/roles/show", type: :view do
  before(:each) do
    @user_role = assign(:user_role, User::Role.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
