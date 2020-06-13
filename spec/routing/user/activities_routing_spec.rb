require "rails_helper"

RSpec.describe User::ActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user/activities").to route_to("user/activities#index")
    end

    it "routes to #new" do
      expect(get: "/user/activities/new").to route_to("user/activities#new")
    end

    it "routes to #show" do
      expect(get: "/user/activities/1").to route_to("user/activities#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user/activities/1/edit").to route_to("user/activities#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user/activities").to route_to("user/activities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user/activities/1").to route_to("user/activities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user/activities/1").to route_to("user/activities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user/activities/1").to route_to("user/activities#destroy", id: "1")
    end
  end
end
