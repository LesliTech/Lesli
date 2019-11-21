require 'rails_helper'

RSpec.describe "bell/notifications/new", type: :view do
  before(:each) do
    assign(:bell_notification, Bell::Notification.new())
  end

  it "renders new bell_notification form" do
    render

    assert_select "form[action=?][method=?]", bell_notifications_path, "post" do
    end
  end
end
