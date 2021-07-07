require 'rails_helper'

RSpec.describe "role/descriptor_assignments/new", type: :view do
  before(:each) do
    assign(:role_descriptor_assignment, Role::DescriptorAssignment.new())
  end

  it "renders new role_descriptor_assignment form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_assignments_path, "post" do
    end
  end
end
