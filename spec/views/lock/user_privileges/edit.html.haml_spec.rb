require 'rails_helper'

RSpec.describe "lock/user_privileges/edit", type: :view do
  before(:each) do
    @lock_user_privilege = assign(:lock_user_privilege, Lock::UserPrivilege.create!())
  end

  it "renders the edit lock_user_privilege form" do
    render

    assert_select "form[action=?][method=?]", lock_user_privilege_path(@lock_user_privilege), "post" do
    end
  end
end
