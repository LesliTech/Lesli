require 'rails_helper'

RSpec.describe "role/privileges/edit", type: :view do
  before(:each) do
    @role_privilege = assign(:role_privilege, Role::Privilege.create!())
  end

  it "renders the edit role_privilege form" do
    render

    assert_select "form[action=?][method=?]", role_privilege_path(@role_privilege), "post" do
    end
  end
end
