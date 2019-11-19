require "rails_helper"

RSpec.describe Lock::UserDetailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lock/user_details").to route_to("lock/user_details#index")
    end

    it "routes to #new" do
      expect(:get => "/lock/user_details/new").to route_to("lock/user_details#new")
    end

    it "routes to #show" do
      expect(:get => "/lock/user_details/1").to route_to("lock/user_details#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lock/user_details/1/edit").to route_to("lock/user_details#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lock/user_details").to route_to("lock/user_details#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lock/user_details/1").to route_to("lock/user_details#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lock/user_details/1").to route_to("lock/user_details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lock/user_details/1").to route_to("lock/user_details#destroy", :id => "1")
    end
  end
end
