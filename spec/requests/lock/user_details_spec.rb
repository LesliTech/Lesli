require 'rails_helper'

RSpec.describe "Lock::UserDetails", type: :request do
  describe "GET /lock/user_details" do
    it "works! (now write some real specs)" do
      get lock_user_details_path
      expect(response).to have_http_status(200)
    end
  end
end
