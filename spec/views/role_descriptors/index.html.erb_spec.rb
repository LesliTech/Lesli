require 'rails_helper'

RSpec.describe "role_descriptors/index", type: :view do
  before(:each) do
    assign(:role_descriptors, [
      RoleDescriptor.create!(),
      RoleDescriptor.create!()
    ])
  end

  it "renders a list of role_descriptors" do
    render
  end
end
