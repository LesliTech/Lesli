require 'rails_helper'

RSpec.describe "Userrs", type: :request do
  describe "GET /userrs" do
    it "works! (now write some real specs)" do
      get userrs_path
      expect(response).to have_http_status(200)
    end
  end
end
