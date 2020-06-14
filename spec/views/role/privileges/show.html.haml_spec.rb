require 'rails_helper'

RSpec.describe "role/privileges/show", type: :view do
  before(:each) do
    @role_privilege = assign(:role_privilege, Role::Privilege.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
