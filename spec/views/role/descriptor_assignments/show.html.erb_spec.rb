require 'rails_helper'

RSpec.describe "role/descriptor_assignments/show", type: :view do
  before(:each) do
    @role_descriptor_assignment = assign(:role_descriptor_assignment, Role::DescriptorAssignment.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
