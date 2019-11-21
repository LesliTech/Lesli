require 'rails_helper'

RSpec.describe "bell/notifications/show", type: :view do
  before(:each) do
    @bell_notification = assign(:bell_notification, Bell::Notification.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
