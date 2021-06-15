require 'rails_helper'

RSpec.describe "role/privilege_groups/index", type: :view do
  before(:each) do
    assign(:role_privilege_groups, [
      Role::PrivilegeGroup.create!(),
      Role::PrivilegeGroup.create!()
    ])
  end

  it "renders a list of role/privilege_groups" do
    render
  end
end
