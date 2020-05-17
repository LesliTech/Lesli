require "rails_helper"

RSpec.describe UserActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_activities").to route_to("user_activities#index")
    end

    it "routes to #new" do
      expect(get: "/user_activities/new").to route_to("user_activities#new")
    end

    it "routes to #show" do
      expect(get: "/user_activities/1").to route_to("user_activities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user_activities/1/edit").to route_to("user_activities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user_activities").to route_to("user_activities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_activities/1").to route_to("user_activities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_activities/1").to route_to("user_activities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_activities/1").to route_to("user_activities#destroy", id: "1")
    end
  end
end
