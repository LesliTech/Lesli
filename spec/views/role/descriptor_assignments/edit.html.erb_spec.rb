require 'rails_helper'

RSpec.describe "role/descriptor_assignments/edit", type: :view do
  before(:each) do
    @role_descriptor_assignment = assign(:role_descriptor_assignment, Role::DescriptorAssignment.create!())
  end

  it "renders the edit role_descriptor_assignment form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_assignment_path(@role_descriptor_assignment), "post" do
    end
  end
end
