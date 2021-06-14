require 'rails_helper'

RSpec.describe "system_controllers/actions/edit", type: :view do
  before(:each) do
    @system_controllers_action = assign(:system_controllers_action, SystemControllers::Action.create!())
  end

  it "renders the edit system_controllers_action form" do
    render

    assert_select "form[action=?][method=?]", system_controllers_action_path(@system_controllers_action), "post" do
    end
  end
end
