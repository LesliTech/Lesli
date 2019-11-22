require 'rails_helper'

RSpec.describe "Assistants", type: :request do
  describe "GET /assistants" do
    it "works! (now write some real specs)" do
      get assistants_path
      expect(response).to have_http_status(200)
    end
  end
end
