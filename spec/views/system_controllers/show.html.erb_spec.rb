require 'rails_helper'

RSpec.describe "system_controllers/show", type: :view do
  before(:each) do
    @system_controller = assign(:system_controller, SystemController.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
