require "rails_helper"

RSpec.describe Lock::UserPrivilegesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/user_privileges").to route_to("lock/user_privileges#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/user_privileges/new").to route_to("lock/user_privileges#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/user_privileges/1").to route_to("lock/user_privileges#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/user_privileges/1/edit").to route_to("lock/user_privileges#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/user_privileges").to route_to("lock/user_privileges#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/user_privileges/1").to route_to("lock/user_privileges#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/user_privileges/1").to route_to("lock/user_privileges#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/user_privileges/1").to route_to("lock/user_privileges#destroy", :id => "1")
    end
  end
end
