require 'rails_helper'

RSpec.describe "bell/messages/show", type: :view do
  before(:each) do
    @bell_message = assign(:bell_message, Bell::Message.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
