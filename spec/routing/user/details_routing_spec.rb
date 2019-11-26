require "rails_helper"

RSpec.describe User::DetailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/user/details").to route_to("user/details#index")
    end

    it "routes to #new" do
      expect(:get => "/user/details/new").to route_to("user/details#new")
    end

    it "routes to #show" do
      expect(:get => "/user/details/1").to route_to("user/details#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user/details/1/edit").to route_to("user/details#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/user/details").to route_to("user/details#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user/details/1").to route_to("user/details#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user/details/1").to route_to("user/details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user/details/1").to route_to("user/details#destroy", :id => "1")
    end
  end
end
