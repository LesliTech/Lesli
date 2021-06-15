require 'rails_helper'

RSpec.describe "role/privilege_groups/show", type: :view do
  before(:each) do
    @role_privilege_group = assign(:role_privilege_group, Role::PrivilegeGroup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
