require 'rails_helper'

RSpec.describe "role/descriptors/index", type: :view do
  before(:each) do
    assign(:role_descriptors, [
      Role::Descriptor.create!(),
      Role::Descriptor.create!()
    ])
  end

  it "renders a list of role/descriptors" do
    render
  end
end
