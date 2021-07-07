require 'rails_helper'

RSpec.describe "role_descriptors/show", type: :view do
  before(:each) do
    @role_descriptor = assign(:role_descriptor, RoleDescriptor.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
