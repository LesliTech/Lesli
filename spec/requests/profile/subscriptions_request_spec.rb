require 'rails_helper'

RSpec.describe "Profile::Subscriptions", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/profile/subscriptions/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/profile/subscriptions/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/profile/subscriptions/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
