require "rails_helper"

RSpec.describe Account::PrivilegeGroupActionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/privilege_group_actions").to route_to("account/privilege_group_actions#index")
    end

    it "routes to #new" do
      expect(get: "/account/privilege_group_actions/new").to route_to("account/privilege_group_actions#new")
    end

    it "routes to #show" do
      expect(get: "/account/privilege_group_actions/1").to route_to("account/privilege_group_actions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/privilege_group_actions/1/edit").to route_to("account/privilege_group_actions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/privilege_group_actions").to route_to("account/privilege_group_actions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/privilege_group_actions/1").to route_to("account/privilege_group_actions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/privilege_group_actions/1").to route_to("account/privilege_group_actions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/privilege_group_actions/1").to route_to("account/privilege_group_actions#destroy", id: "1")
    end
  end
end
