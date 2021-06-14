require "rails_helper"

RSpec.describe User::PrivilegeActionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user/privilege_actions").to route_to("user/privilege_actions#index")
    end

    it "routes to #new" do
      expect(get: "/user/privilege_actions/new").to route_to("user/privilege_actions#new")
    end

    it "routes to #show" do
      expect(get: "/user/privilege_actions/1").to route_to("user/privilege_actions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user/privilege_actions/1/edit").to route_to("user/privilege_actions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user/privilege_actions").to route_to("user/privilege_actions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user/privilege_actions/1").to route_to("user/privilege_actions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user/privilege_actions/1").to route_to("user/privilege_actions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user/privilege_actions/1").to route_to("user/privilege_actions#destroy", id: "1")
    end
  end
end
