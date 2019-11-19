require 'rails_helper'

RSpec.describe "Bell::Messages", type: :request do
  describe "GET /bell/messages" do
    it "works! (now write some real specs)" do
      get bell_messages_path
      expect(response).to have_http_status(200)
    end
  end
end
