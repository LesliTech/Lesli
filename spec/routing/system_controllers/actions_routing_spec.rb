require "rails_helper"

RSpec.describe SystemControllers::ActionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/system_controllers/actions").to route_to("system_controllers/actions#index")
    end

    it "routes to #new" do
      expect(get: "/system_controllers/actions/new").to route_to("system_controllers/actions#new")
    end

    it "routes to #show" do
      expect(get: "/system_controllers/actions/1").to route_to("system_controllers/actions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/system_controllers/actions/1/edit").to route_to("system_controllers/actions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/system_controllers/actions").to route_to("system_controllers/actions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/system_controllers/actions/1").to route_to("system_controllers/actions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/system_controllers/actions/1").to route_to("system_controllers/actions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/system_controllers/actions/1").to route_to("system_controllers/actions#destroy", id: "1")
    end
  end
end
