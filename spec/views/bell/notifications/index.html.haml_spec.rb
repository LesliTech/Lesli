require 'rails_helper'

RSpec.describe "bell/notifications/index", type: :view do
  before(:each) do
    assign(:bell_notifications, [
      Bell::Notification.create!(),
      Bell::Notification.create!()
    ])
  end

  it "renders a list of bell/notifications" do
    render
  end
end
