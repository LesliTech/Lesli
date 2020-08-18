require 'rails_helper'

RSpec.describe "system_activities/index", type: :view do
  before(:each) do
    assign(:system_activities, [
      SystemActivity.create!(),
      SystemActivity.create!()
    ])
  end

  it "renders a list of system_activities" do
    render
  end
end
