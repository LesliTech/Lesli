require 'rails_helper'

RSpec.describe "bell/messages/edit", type: :view do
  before(:each) do
    @bell_message = assign(:bell_message, Bell::Message.create!())
  end

  it "renders the edit bell_message form" do
    render

    assert_select "form[action=?][method=?]", bell_message_path(@bell_message), "post" do
    end
  end
end
