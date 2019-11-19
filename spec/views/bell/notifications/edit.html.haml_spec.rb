require 'rails_helper'

RSpec.describe "bell/notifications/edit", type: :view do
  before(:each) do
    @bell_notification = assign(:bell_notification, Bell::Notification.create!())
  end

  it "renders the edit bell_notification form" do
    render

    assert_select "form[action=?][method=?]", bell_notification_path(@bell_notification), "post" do
    end
  end
end
