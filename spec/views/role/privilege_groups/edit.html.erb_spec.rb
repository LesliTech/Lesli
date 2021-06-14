require 'rails_helper'

RSpec.describe "role/privilege_groups/edit", type: :view do
  before(:each) do
    @role_privilege_group = assign(:role_privilege_group, Role::PrivilegeGroup.create!())
  end

  it "renders the edit role_privilege_group form" do
    render

    assert_select "form[action=?][method=?]", role_privilege_group_path(@role_privilege_group), "post" do
    end
  end
end
