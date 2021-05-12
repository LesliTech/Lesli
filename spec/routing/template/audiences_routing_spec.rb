require "rails_helper"

RSpec.describe Template::AudiencesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/audiences").to route_to("template/audiences#index")
    end

    it "routes to #new" do
      expect(get: "/template/audiences/new").to route_to("template/audiences#new")
    end

    it "routes to #show" do
      expect(get: "/template/audiences/1").to route_to("template/audiences#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/audiences/1/edit").to route_to("template/audiences#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/audiences").to route_to("template/audiences#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/audiences/1").to route_to("template/audiences#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/audiences/1").to route_to("template/audiences#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/audiences/1").to route_to("template/audiences#destroy", id: "1")
    end
  end
end
