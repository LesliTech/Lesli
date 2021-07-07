require "rails_helper"

RSpec.describe RoleDescriptor::ActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role_descriptor/activities").to route_to("role_descriptor/activities#index")
    end

    it "routes to #new" do
      expect(get: "/role_descriptor/activities/new").to route_to("role_descriptor/activities#new")
    end

    it "routes to #show" do
      expect(get: "/role_descriptor/activities/1").to route_to("role_descriptor/activities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role_descriptor/activities/1/edit").to route_to("role_descriptor/activities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role_descriptor/activities").to route_to("role_descriptor/activities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role_descriptor/activities/1").to route_to("role_descriptor/activities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role_descriptor/activities/1").to route_to("role_descriptor/activities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role_descriptor/activities/1").to route_to("role_descriptor/activities#destroy", id: "1")
    end
  end
end
