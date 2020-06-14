require "rails_helper"

RSpec.describe Account::SettingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/account/settings").to route_to("account/settings#index")
    end

    it "routes to #new" do
      expect(get: "/account/settings/new").to route_to("account/settings#new")
    end

    it "routes to #show" do
      expect(get: "/account/settings/1").to route_to("account/settings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/account/settings/1/edit").to route_to("account/settings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/account/settings").to route_to("account/settings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/account/settings/1").to route_to("account/settings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/account/settings/1").to route_to("account/settings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/account/settings/1").to route_to("account/settings#destroy", id: "1")
    end
  end
end
