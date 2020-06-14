require "rails_helper"

RSpec.describe Account::LocationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/locations").to route_to("account/locations#index")
    end

    it "routes to #new" do
      expect(get: "/account/locations/new").to route_to("account/locations#new")
    end

    it "routes to #show" do
      expect(get: "/account/locations/1").to route_to("account/locations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/locations/1/edit").to route_to("account/locations#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/locations").to route_to("account/locations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/locations/1").to route_to("account/locations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/locations/1").to route_to("account/locations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/locations/1").to route_to("account/locations#destroy", id: "1")
    end
  end
end
