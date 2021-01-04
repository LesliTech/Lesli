require 'rails_helper'

RSpec.describe "role/activities/index", type: :view do
  before(:each) do
    assign(:role_activities, [
      Role::Activity.create!(),
      Role::Activity.create!()
    ])
  end

  it "renders a list of role/activities" do
    render
  end
end
