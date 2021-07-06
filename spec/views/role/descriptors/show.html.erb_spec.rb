require 'rails_helper'

RSpec.describe "role/descriptors/show", type: :view do
  before(:each) do
    @role_descriptor = assign(:role_descriptor, Role::Descriptor.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
