require 'rails_helper'

RSpec.describe "Bell::Notifications", type: :request do
  describe "GET /bell/notifications" do
    it "works! (now write some real specs)" do
      get bell_notifications_path
      expect(response).to have_http_status(200)
    end
  end
end
