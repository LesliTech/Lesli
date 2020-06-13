require 'rails_helper'

RSpec.describe "role/privileges/index", type: :view do
  before(:each) do
    assign(:role_privileges, [
      Role::Privilege.create!(),
      Role::Privilege.create!()
    ])
  end

  it "renders a list of role/privileges" do
    render
  end
end
