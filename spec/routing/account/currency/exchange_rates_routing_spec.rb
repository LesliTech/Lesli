require "rails_helper"

RSpec.describe Account::Currency::ExchangeRatesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/currency/exchange_rates").to route_to("account/currency/exchange_rates#index")
    end

    it "routes to #new" do
      expect(get: "/account/currency/exchange_rates/new").to route_to("account/currency/exchange_rates#new")
    end

    it "routes to #show" do
      expect(get: "/account/currency/exchange_rates/1").to route_to("account/currency/exchange_rates#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/currency/exchange_rates/1/edit").to route_to("account/currency/exchange_rates#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/currency/exchange_rates").to route_to("account/currency/exchange_rates#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/currency/exchange_rates/1").to route_to("account/currency/exchange_rates#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/currency/exchange_rates/1").to route_to("account/currency/exchange_rates#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/currency/exchange_rates/1").to route_to("account/currency/exchange_rates#destroy", id: "1")
    end
  end
end
