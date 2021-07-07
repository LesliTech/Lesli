require 'rails_helper'

RSpec.describe "role/descriptor_assignments/index", type: :view do
  before(:each) do
    assign(:role_descriptor_assignments, [
      Role::DescriptorAssignment.create!(),
      Role::DescriptorAssignment.create!()
    ])
  end

  it "renders a list of role/descriptor_assignments" do
    render
  end
end
