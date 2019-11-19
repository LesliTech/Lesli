require 'rails_helper'

RSpec.describe "lock/user_roles/new", type: :view do
  before(:each) do
    assign(:lock_user_role, Lock::UserRole.new())
  end

  it "renders new lock_user_role form" do
    render

    assert_select "form[action=?][method=?]", lock_user_roles_path, "post" do
    end
  end
end
