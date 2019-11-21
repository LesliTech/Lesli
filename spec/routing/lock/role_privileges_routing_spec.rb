require "rails_helper"

RSpec.describe Lock::RolePrivilegesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/role_privileges").to route_to("lock/role_privileges#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/role_privileges/new").to route_to("lock/role_privileges#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/role_privileges/1").to route_to("lock/role_privileges#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/role_privileges/1/edit").to route_to("lock/role_privileges#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/role_privileges").to route_to("lock/role_privileges#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/role_privileges/1").to route_to("lock/role_privileges#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/role_privileges/1").to route_to("lock/role_privileges#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/role_privileges/1").to route_to("lock/role_privileges#destroy", :id => "1")
    end
  end
end
