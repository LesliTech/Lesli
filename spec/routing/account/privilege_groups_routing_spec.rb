require "rails_helper"

RSpec.describe Account::PrivilegeGroupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/privilege_groups").to route_to("account/privilege_groups#index")
    end

    it "routes to #new" do
      expect(get: "/account/privilege_groups/new").to route_to("account/privilege_groups#new")
    end

    it "routes to #show" do
      expect(get: "/account/privilege_groups/1").to route_to("account/privilege_groups#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/privilege_groups/1/edit").to route_to("account/privilege_groups#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/privilege_groups").to route_to("account/privilege_groups#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/privilege_groups/1").to route_to("account/privilege_groups#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/privilege_groups/1").to route_to("account/privilege_groups#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/privilege_groups/1").to route_to("account/privilege_groups#destroy", id: "1")
    end
  end
end
