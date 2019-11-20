require 'rails_helper'

RSpec.describe "lock/roles/new", type: :view do
  before(:each) do
    assign(:lock_role, Lock::Role.new())
  end

  it "renders new lock_role form" do
    render

    assert_select "form[action=?][method=?]", lock_roles_path, "post" do
    end
  end
end
