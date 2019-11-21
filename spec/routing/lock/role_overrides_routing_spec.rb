require "rails_helper"

RSpec.describe Lock::RoleOverridesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/role_overrides").to route_to("lock/role_overrides#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/role_overrides/new").to route_to("lock/role_overrides#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/role_overrides/1").to route_to("lock/role_overrides#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/role_overrides/1/edit").to route_to("lock/role_overrides#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/role_overrides").to route_to("lock/role_overrides#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/role_overrides/1").to route_to("lock/role_overrides#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/role_overrides/1").to route_to("lock/role_overrides#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/role_overrides/1").to route_to("lock/role_overrides#destroy", :id => "1")
    end
  end
end
