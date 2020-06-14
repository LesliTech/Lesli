require "rails_helper"

RSpec.describe Role::PrivilegesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/privileges").to route_to("role/privileges#index")
    end

    it "routes to #new" do
      expect(get: "/role/privileges/new").to route_to("role/privileges#new")
    end

    it "routes to #show" do
      expect(get: "/role/privileges/1").to route_to("role/privileges#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/privileges/1/edit").to route_to("role/privileges#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/privileges").to route_to("role/privileges#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/privileges/1").to route_to("role/privileges#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/privileges/1").to route_to("role/privileges#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/privileges/1").to route_to("role/privileges#destroy", id: "1")
    end
  end
end
