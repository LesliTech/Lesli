require "rails_helper"

RSpec.describe Role::DetailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/details").to route_to("role/details#index")
    end

    it "routes to #new" do
      expect(get: "/role/details/new").to route_to("role/details#new")
    end

    it "routes to #show" do
      expect(get: "/role/details/1").to route_to("role/details#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/details/1/edit").to route_to("role/details#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/details").to route_to("role/details#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/details/1").to route_to("role/details#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/details/1").to route_to("role/details#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/details/1").to route_to("role/details#destroy", id: "1")
    end
  end
end
