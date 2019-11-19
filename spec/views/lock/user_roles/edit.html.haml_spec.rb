require 'rails_helper'

RSpec.describe "lock/user_roles/edit", type: :view do
  before(:each) do
    @lock_user_role = assign(:lock_user_role, Lock::UserRole.create!())
  end

  it "renders the edit lock_user_role form" do
    render

    assert_select "form[action=?][method=?]", lock_user_role_path(@lock_user_role), "post" do
    end
  end
end
