require "rails_helper"

RSpec.describe Role::DescriptorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/descriptors").to route_to("role/descriptors#index")
    end

    it "routes to #new" do
      expect(get: "/role/descriptors/new").to route_to("role/descriptors#new")
    end

    it "routes to #show" do
      expect(get: "/role/descriptors/1").to route_to("role/descriptors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/descriptors/1/edit").to route_to("role/descriptors#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/descriptors").to route_to("role/descriptors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/descriptors/1").to route_to("role/descriptors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/descriptors/1").to route_to("role/descriptors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/descriptors/1").to route_to("role/descriptors#destroy", id: "1")
    end
  end
end
