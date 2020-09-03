require "rails_helper"

RSpec.describe Template::DocumentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/documents").to route_to("template/documents#index")
    end

    it "routes to #new" do
      expect(get: "/template/documents/new").to route_to("template/documents#new")
    end

    it "routes to #show" do
      expect(get: "/template/documents/1").to route_to("template/documents#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/documents/1/edit").to route_to("template/documents#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/documents").to route_to("template/documents#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/documents/1").to route_to("template/documents#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/documents/1").to route_to("template/documents#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/documents/1").to route_to("template/documents#destroy", id: "1")
    end
  end
end
