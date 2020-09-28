require "rails_helper"

RSpec.describe User::LogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user/logs").to route_to("user/logs#index")
    end

    it "routes to #new" do
      expect(get: "/user/logs/new").to route_to("user/logs#new")
    end

    it "routes to #show" do
      expect(get: "/user/logs/1").to route_to("user/logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user/logs/1/edit").to route_to("user/logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user/logs").to route_to("user/logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user/logs/1").to route_to("user/logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user/logs/1").to route_to("user/logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user/logs/1").to route_to("user/logs#destroy", id: "1")
    end
  end
end
