require 'rails_helper'

RSpec.describe "role_descriptor/activities/edit", type: :view do
  before(:each) do
    @role_descriptor_activity = assign(:role_descriptor_activity, RoleDescriptor::Activity.create!())
  end

  it "renders the edit role_descriptor_activity form" do
    render

    assert_select "form[action=?][method=?]", role_descriptor_activity_path(@role_descriptor_activity), "post" do
    end
  end
end
