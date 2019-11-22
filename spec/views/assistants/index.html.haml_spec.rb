require 'rails_helper'

RSpec.describe "assistants/index", type: :view do
  before(:each) do
    assign(:assistants, [
      Assistant.create!(),
      Assistant.create!()
    ])
  end

  it "renders a list of assistants" do
    render
  end
end
