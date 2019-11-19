require 'rails_helper'

RSpec.describe "bell/messages/new", type: :view do
  before(:each) do
    assign(:bell_message, Bell::Message.new())
  end

  it "renders new bell_message form" do
    render

    assert_select "form[action=?][method=?]", bell_messages_path, "post" do
    end
  end
end
