require "rails_helper"

RSpec.describe Template::VariablesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/variables").to route_to("template/variables#index")
    end

    it "routes to #new" do
      expect(get: "/template/variables/new").to route_to("template/variables#new")
    end

    it "routes to #show" do
      expect(get: "/template/variables/1").to route_to("template/variables#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/variables/1/edit").to route_to("template/variables#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/variables").to route_to("template/variables#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/variables/1").to route_to("template/variables#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/variables/1").to route_to("template/variables#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/variables/1").to route_to("template/variables#destroy", id: "1")
    end
  end
end
