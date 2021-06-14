require 'rails_helper'

RSpec.describe "system_controllers/actions/index", type: :view do
  before(:each) do
    assign(:system_controllers_actions, [
      SystemControllers::Action.create!(),
      SystemControllers::Action.create!()
    ])
  end

  it "renders a list of system_controllers/actions" do
    render
  end
end
