require "rails_helper"

RSpec.describe UserrsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/userrs").to route_to("userrs#index")
    end

    it "routes to #new" do
      expect(:get => "/userrs/new").to route_to("userrs#new")
    end

    it "routes to #show" do
      expect(:get => "/userrs/1").to route_to("userrs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/userrs/1/edit").to route_to("userrs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/userrs").to route_to("userrs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/userrs/1").to route_to("userrs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/userrs/1").to route_to("userrs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/userrs/1").to route_to("userrs#destroy", :id => "1")
    end
  end
end
