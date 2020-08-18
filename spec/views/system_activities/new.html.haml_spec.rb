require 'rails_helper'

RSpec.describe "system_activities/new", type: :view do
  before(:each) do
    assign(:system_activity, SystemActivity.new())
  end

  it "renders new system_activity form" do
    render

    assert_select "form[action=?][method=?]", system_activities_path, "post" do
    end
  end
end
