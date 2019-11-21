require 'rails_helper'

RSpec.describe "bell/messages/index", type: :view do
  before(:each) do
    assign(:bell_messages, [
      Bell::Message.create!(),
      Bell::Message.create!()
    ])
  end

  it "renders a list of bell/messages" do
    render
  end
end
