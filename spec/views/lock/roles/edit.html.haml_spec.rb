require 'rails_helper'

RSpec.describe "lock/roles/edit", type: :view do
  before(:each) do
    @lock_role = assign(:lock_role, Lock::Role.create!())
  end

  it "renders the edit lock_role form" do
    render

    assert_select "form[action=?][method=?]", lock_role_path(@lock_role), "post" do
    end
  end
end
