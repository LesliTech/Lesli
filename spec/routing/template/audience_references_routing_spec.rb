require "rails_helper"

RSpec.describe Template::AudienceReferencesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/audience_references").to route_to("template/audience_references#index")
    end

    it "routes to #new" do
      expect(get: "/template/audience_references/new").to route_to("template/audience_references#new")
    end

    it "routes to #show" do
      expect(get: "/template/audience_references/1").to route_to("template/audience_references#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/audience_references/1/edit").to route_to("template/audience_references#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/audience_references").to route_to("template/audience_references#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/audience_references/1").to route_to("template/audience_references#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/audience_references/1").to route_to("template/audience_references#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/audience_references/1").to route_to("template/audience_references#destroy", id: "1")
    end
  end
end
