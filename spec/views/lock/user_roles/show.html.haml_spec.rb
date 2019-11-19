require 'rails_helper'

RSpec.describe "lock/user_roles/show", type: :view do
  before(:each) do
    @lock_user_role = assign(:lock_user_role, Lock::UserRole.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
