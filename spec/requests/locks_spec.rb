require 'rails_helper'

RSpec.describe "Locks", type: :request do
  describe "GET /locks" do
    it "works! (now write some real specs)" do
      get locks_path
      expect(response).to have_http_status(200)
    end
  end
end
