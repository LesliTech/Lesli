require "rails_helper"

RSpec.describe Account::CurrenciesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/currencies").to route_to("account/currencies#index")
    end

    it "routes to #new" do
      expect(get: "/account/currencies/new").to route_to("account/currencies#new")
    end

    it "routes to #show" do
      expect(get: "/account/currencies/1").to route_to("account/currencies#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/currencies/1/edit").to route_to("account/currencies#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/currencies").to route_to("account/currencies#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/currencies/1").to route_to("account/currencies#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/currencies/1").to route_to("account/currencies#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/currencies/1").to route_to("account/currencies#destroy", id: "1")
    end
  end
end
