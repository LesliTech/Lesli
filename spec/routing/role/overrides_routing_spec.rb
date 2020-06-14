require "rails_helper"

RSpec.describe Role::OverridesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/overrides").to route_to("role/overrides#index")
    end

    it "routes to #new" do
      expect(get: "/role/overrides/new").to route_to("role/overrides#new")
    end

    it "routes to #show" do
      expect(get: "/role/overrides/1").to route_to("role/overrides#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/overrides/1/edit").to route_to("role/overrides#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/overrides").to route_to("role/overrides#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/overrides/1").to route_to("role/overrides#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/overrides/1").to route_to("role/overrides#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/overrides/1").to route_to("role/overrides#destroy", id: "1")
    end
  end
end
