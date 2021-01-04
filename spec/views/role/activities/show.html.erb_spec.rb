require 'rails_helper'

RSpec.describe "role/activities/show", type: :view do
  before(:each) do
    @role_activity = assign(:role_activity, Role::Activity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
