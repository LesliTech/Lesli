require "rails_helper"

RSpec.describe User::SettingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user/settings").to route_to("user/settings#index")
    end

    it "routes to #new" do
      expect(get: "/user/settings/new").to route_to("user/settings#new")
    end

    it "routes to #show" do
      expect(get: "/user/settings/1").to route_to("user/settings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user/settings/1/edit").to route_to("user/settings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user/settings").to route_to("user/settings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user/settings/1").to route_to("user/settings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user/settings/1").to route_to("user/settings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user/settings/1").to route_to("user/settings#destroy", id: "1")
    end
  end
end
