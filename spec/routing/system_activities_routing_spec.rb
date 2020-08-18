require "rails_helper"

RSpec.describe SystemActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/system_activities").to route_to("system_activities#index")
    end

    it "routes to #new" do
      expect(get: "/system_activities/new").to route_to("system_activities#new")
    end

    it "routes to #show" do
      expect(get: "/system_activities/1").to route_to("system_activities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/system_activities/1/edit").to route_to("system_activities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/system_activities").to route_to("system_activities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/system_activities/1").to route_to("system_activities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/system_activities/1").to route_to("system_activities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/system_activities/1").to route_to("system_activities#destroy", id: "1")
    end
  end
end
