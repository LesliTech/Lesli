require "rails_helper"

RSpec.describe Template::AudienceDocumentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/audience_documents").to route_to("template/audience_documents#index")
    end

    it "routes to #new" do
      expect(get: "/template/audience_documents/new").to route_to("template/audience_documents#new")
    end

    it "routes to #show" do
      expect(get: "/template/audience_documents/1").to route_to("template/audience_documents#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/audience_documents/1/edit").to route_to("template/audience_documents#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/audience_documents").to route_to("template/audience_documents#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/audience_documents/1").to route_to("template/audience_documents#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/audience_documents/1").to route_to("template/audience_documents#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/audience_documents/1").to route_to("template/audience_documents#destroy", id: "1")
    end
  end
end
