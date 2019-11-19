require "rails_helper"

RSpec.describe LocksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/locks").to route_to("locks#index")
    end

    it "routes to #new" do
      expect(:get => "/locks/new").to route_to("locks#new")
    end

    it "routes to #show" do
      expect(:get => "/locks/1").to route_to("locks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/locks/1/edit").to route_to("locks#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/locks").to route_to("locks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/locks/1").to route_to("locks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/locks/1").to route_to("locks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/locks/1").to route_to("locks#destroy", :id => "1")
    end
  end
end
