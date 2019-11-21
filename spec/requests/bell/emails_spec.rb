require 'rails_helper'

RSpec.describe "Bell::Emails", type: :request do
  describe "GET /bell/emails" do
    it "works! (now write some real specs)" do
      get bell_emails_path
      expect(response).to have_http_status(200)
    end
  end
end
