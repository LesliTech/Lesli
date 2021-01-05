require 'rails_helper'

RSpec.describe "role/activities/new", type: :view do
  before(:each) do
    assign(:role_activity, Role::Activity.new())
  end

  it "renders new role_activity form" do
    render

    assert_select "form[action=?][method=?]", role_activities_path, "post" do
    end
  end
end
