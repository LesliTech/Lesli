require 'rails_helper'

RSpec.describe "CustomFields", type: :request do
  describe "GET /custom_fields" do
    it "works! (now write some real specs)" do
      get custom_fields_path
      expect(response).to have_http_status(200)
    end
  end
end
