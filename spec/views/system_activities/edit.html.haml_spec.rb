require 'rails_helper'

RSpec.describe "system_activities/edit", type: :view do
  before(:each) do
    @system_activity = assign(:system_activity, SystemActivity.create!())
  end

  it "renders the edit system_activity form" do
    render

    assert_select "form[action=?][method=?]", system_activity_path(@system_activity), "post" do
    end
  end
end
