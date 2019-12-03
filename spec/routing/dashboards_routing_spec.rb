require "rails_helper"

RSpec.describe DashboardsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/dashboards").to route_to("dashboards#index")
    end

    it "routes to #new" do
      expect(:get => "/dashboards/new").to route_to("dashboards#new")
    end

    it "routes to #show" do
      expect(:get => "/dashboards/1").to route_to("dashboards#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dashboards/1/edit").to route_to("dashboards#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/dashboards").to route_to("dashboards#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dashboards/1").to route_to("dashboards#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dashboards/1").to route_to("dashboards#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dashboards/1").to route_to("dashboards#destroy", :id => "1")
    end
  end
end
