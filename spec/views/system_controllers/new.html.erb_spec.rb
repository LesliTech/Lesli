require 'rails_helper'

RSpec.describe "system_controllers/new", type: :view do
  before(:each) do
    assign(:system_controller, SystemController.new())
  end

  it "renders new system_controller form" do
    render

    assert_select "form[action=?][method=?]", system_controllers_path, "post" do
    end
  end
end
