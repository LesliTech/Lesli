require "rails_helper"

RSpec.describe Lock::RolesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/roles").to route_to("lock/roles#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/roles/new").to route_to("lock/roles#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/roles/1").to route_to("lock/roles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/roles/1/edit").to route_to("lock/roles#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/roles").to route_to("lock/roles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/roles/1").to route_to("lock/roles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/roles/1").to route_to("lock/roles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/roles/1").to route_to("lock/roles#destroy", :id => "1")
    end
  end
end
