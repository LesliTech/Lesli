require 'rails_helper'

RSpec.describe "system_controllers/index", type: :view do
  before(:each) do
    assign(:system_controllers, [
      SystemController.create!(),
      SystemController.create!()
    ])
  end

  it "renders a list of system_controllers" do
    render
  end
end
