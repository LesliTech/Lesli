require 'rails_helper'

RSpec.describe "role_descriptors/new", type: :view do
  before(:each) do
    assign(:role_descriptor, RoleDescriptor.new())
  end

  it "renders new role_descriptor form" do
    render

    assert_select "form[action=?][method=?]", role_descriptors_path, "post" do
    end
  end
end
