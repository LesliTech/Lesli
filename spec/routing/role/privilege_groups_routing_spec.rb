require "rails_helper"

RSpec.describe Role::PrivilegeGroupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/privilege_groups").to route_to("role/privilege_groups#index")
    end

    it "routes to #new" do
      expect(get: "/role/privilege_groups/new").to route_to("role/privilege_groups#new")
    end

    it "routes to #show" do
      expect(get: "/role/privilege_groups/1").to route_to("role/privilege_groups#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/privilege_groups/1/edit").to route_to("role/privilege_groups#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/privilege_groups").to route_to("role/privilege_groups#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/privilege_groups/1").to route_to("role/privilege_groups#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/privilege_groups/1").to route_to("role/privilege_groups#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/privilege_groups/1").to route_to("role/privilege_groups#destroy", id: "1")
    end
  end
end
