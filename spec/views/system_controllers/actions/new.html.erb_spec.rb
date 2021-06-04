require 'rails_helper'

RSpec.describe "system_controllers/actions/new", type: :view do
  before(:each) do
    assign(:system_controllers_action, SystemControllers::Action.new())
  end

  it "renders new system_controllers_action form" do
    render

    assert_select "form[action=?][method=?]", system_controllers_actions_path, "post" do
    end
  end
end
