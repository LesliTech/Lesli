require "rails_helper"

RSpec.describe Lock::UserRolesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/user_roles").to route_to("lock/user_roles#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/user_roles/new").to route_to("lock/user_roles#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/user_roles/1").to route_to("lock/user_roles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/user_roles/1/edit").to route_to("lock/user_roles#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/user_roles").to route_to("lock/user_roles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/user_roles/1").to route_to("lock/user_roles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/user_roles/1").to route_to("lock/user_roles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/user_roles/1").to route_to("lock/user_roles#destroy", :id => "1")
    end
  end
end
