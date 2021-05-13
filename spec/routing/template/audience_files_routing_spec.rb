require "rails_helper"

RSpec.describe Template::AudienceFilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/template/audience_files").to route_to("template/audience_files#index")
    end

    it "routes to #new" do
      expect(get: "/template/audience_files/new").to route_to("template/audience_files#new")
    end

    it "routes to #show" do
      expect(get: "/template/audience_files/1").to route_to("template/audience_files#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/template/audience_files/1/edit").to route_to("template/audience_files#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/template/audience_files").to route_to("template/audience_files#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/template/audience_files/1").to route_to("template/audience_files#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/template/audience_files/1").to route_to("template/audience_files#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/template/audience_files/1").to route_to("template/audience_files#destroy", id: "1")
    end
  end
end
