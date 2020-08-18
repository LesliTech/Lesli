require 'rails_helper'

RSpec.describe "system_activities/show", type: :view do
  before(:each) do
    @system_activity = assign(:system_activity, SystemActivity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
