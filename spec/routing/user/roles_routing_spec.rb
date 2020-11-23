require "rails_helper"

RSpec.describe User::RolesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user/roles").to route_to("user/roles#index")
    end

    it "routes to #new" do
      expect(get: "/user/roles/new").to route_to("user/roles#new")
    end

    it "routes to #show" do
      expect(get: "/user/roles/1").to route_to("user/roles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user/roles/1/edit").to route_to("user/roles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user/roles").to route_to("user/roles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user/roles/1").to route_to("user/roles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user/roles/1").to route_to("user/roles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user/roles/1").to route_to("user/roles#destroy", id: "1")
    end
  end
end
