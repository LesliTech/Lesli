require 'rails_helper'

RSpec.describe "role/privileges/new", type: :view do
  before(:each) do
    assign(:role_privilege, Role::Privilege.new())
  end

  it "renders new role_privilege form" do
    render

    assert_select "form[action=?][method=?]", role_privileges_path, "post" do
    end
  end
end
