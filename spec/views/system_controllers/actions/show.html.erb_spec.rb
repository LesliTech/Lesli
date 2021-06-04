require 'rails_helper'

RSpec.describe "system_controllers/actions/show", type: :view do
  before(:each) do
    @system_controllers_action = assign(:system_controllers_action, SystemControllers::Action.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
