require "rails_helper"

RSpec.describe RoleDescriptorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role_descriptors").to route_to("role_descriptors#index")
    end

    it "routes to #new" do
      expect(get: "/role_descriptors/new").to route_to("role_descriptors#new")
    end

    it "routes to #show" do
      expect(get: "/role_descriptors/1").to route_to("role_descriptors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role_descriptors/1/edit").to route_to("role_descriptors#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role_descriptors").to route_to("role_descriptors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role_descriptors/1").to route_to("role_descriptors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role_descriptors/1").to route_to("role_descriptors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role_descriptors/1").to route_to("role_descriptors#destroy", id: "1")
    end
  end
end
