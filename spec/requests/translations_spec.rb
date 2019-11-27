require 'rails_helper'

RSpec.describe "Translations", type: :request do
  describe "GET /translations" do
    it "works! (now write some real specs)" do
      get translations_path
      expect(response).to have_http_status(200)
    end
  end
end
