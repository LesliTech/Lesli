require 'rails_helper'

RSpec.describe "system_controllers/edit", type: :view do
  before(:each) do
    @system_controller = assign(:system_controller, SystemController.create!())
  end

  it "renders the edit system_controller form" do
    render

    assert_select "form[action=?][method=?]", system_controller_path(@system_controller), "post" do
    end
  end
end
