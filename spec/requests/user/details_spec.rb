require 'rails_helper'

RSpec.describe "User::Details", type: :request do
  describe "GET /user/details" do
    it "works! (now write some real specs)" do
      get user_details_path
      expect(response).to have_http_status(200)
    end
  end
end
