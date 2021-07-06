require 'rails_helper'

RSpec.describe "role_descriptors/edit", type: :view do
  before(:each) do
    @role_descriptor = assign(:role_descriptor, RoleDescriptor.create!())
  end

  it "renders the edit role_descriptor form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_path(@role_descriptor), "post" do
    end
  end
end
