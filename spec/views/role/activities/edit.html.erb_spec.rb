require 'rails_helper'

RSpec.describe "role/activities/edit", type: :view do
  before(:each) do
    @role_activity = assign(:role_activity, Role::Activity.create!())
  end

  it "renders the edit role_activity form" do
    render

    assert_select "form[action=?][method=?]", role_activity_path(@role_activity), "post" do
    end
  end
end
