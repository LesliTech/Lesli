require 'rails_helper'

RSpec.describe "role_descriptor/activities/new", type: :view do
  before(:each) do
    assign(:role_descriptor_activity, RoleDescriptor::Activity.new())
  end

  it "renders new role_descriptor_activity form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_activities_path, "post" do
    end
  end
end
