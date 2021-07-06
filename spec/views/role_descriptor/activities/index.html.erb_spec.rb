require 'rails_helper'

RSpec.describe "role_descriptor/activities/index", type: :view do
  before(:each) do
    assign(:role_descriptor_activities, [
      RoleDescriptor::Activity.create!(),
      RoleDescriptor::Activity.create!()
    ])
  end

  it "renders a list of role_descriptor/activities" do
    render
  end
end
