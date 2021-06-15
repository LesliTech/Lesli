require 'rails_helper'

RSpec.describe "role/privilege_groups/new", type: :view do
  before(:each) do
    assign(:role_privilege_group, Role::PrivilegeGroup.new())
  end

  it "renders new role_privilege_group form" do
    render

    assert_select "form[action=?][method=?]", role_privilege_groups_path, "post" do
    end
  end
end
