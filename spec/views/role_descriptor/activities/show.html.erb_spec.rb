require 'rails_helper'

RSpec.describe "role_descriptor/activities/show", type: :view do
  before(:each) do
    @role_descriptor_activity = assign(:role_descriptor_activity, RoleDescriptor::Activity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
