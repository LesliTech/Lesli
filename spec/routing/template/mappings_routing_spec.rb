require "rails_helper"

RSpec.describe Template::MappingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/mappings").to route_to("template/mappings#index")
    end

    it "routes to #new" do
      expect(get: "/template/mappings/new").to route_to("template/mappings#new")
    end

    it "routes to #show" do
      expect(get: "/template/mappings/1").to route_to("template/mappings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/mappings/1/edit").to route_to("template/mappings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/mappings").to route_to("template/mappings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/mappings/1").to route_to("template/mappings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/mappings/1").to route_to("template/mappings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/mappings/1").to route_to("template/mappings#destroy", id: "1")
    end
  end
end
