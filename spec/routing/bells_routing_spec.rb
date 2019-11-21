require "rails_helper"

RSpec.describe BellsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/bells").to route_to("bells#index")
    end

    it "routes to #new" do
      expect(:get => "/bells/new").to route_to("bells#new")
    end

    it "routes to #show" do
      expect(:get => "/bells/1").to route_to("bells#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bells/1/edit").to route_to("bells#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/bells").to route_to("bells#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bells/1").to route_to("bells#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bells/1").to route_to("bells#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bells/1").to route_to("bells#destroy", :id => "1")
    end
  end
end
