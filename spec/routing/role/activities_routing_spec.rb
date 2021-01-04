require "rails_helper"

RSpec.describe Role::ActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/activities").to route_to("role/activities#index")
    end

    it "routes to #new" do
      expect(get: "/role/activities/new").to route_to("role/activities#new")
    end

    it "routes to #show" do
      expect(get: "/role/activities/1").to route_to("role/activities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/activities/1/edit").to route_to("role/activities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/activities").to route_to("role/activities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/activities/1").to route_to("role/activities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/activities/1").to route_to("role/activities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/activities/1").to route_to("role/activities#destroy", id: "1")
    end
  end
end
