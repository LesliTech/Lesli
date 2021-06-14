require "rails_helper"

RSpec.describe SystemControllersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/system_controllers").to route_to("system_controllers#index")
    end

    it "routes to #new" do
      expect(get: "/system_controllers/new").to route_to("system_controllers#new")
    end

    it "routes to #show" do
      expect(get: "/system_controllers/1").to route_to("system_controllers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/system_controllers/1/edit").to route_to("system_controllers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/system_controllers").to route_to("system_controllers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/system_controllers/1").to route_to("system_controllers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/system_controllers/1").to route_to("system_controllers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/system_controllers/1").to route_to("system_controllers#destroy", id: "1")
    end
  end
end
