require "rails_helper"

RSpec.describe Bell::NotificationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/bell/notifications").to route_to("bell/notifications#index")
    end

    it "routes to #new" do
      expect(:get => "/bell/notifications/new").to route_to("bell/notifications#new")
    end

    it "routes to #show" do
      expect(:get => "/bell/notifications/1").to route_to("bell/notifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bell/notifications/1/edit").to route_to("bell/notifications#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/bell/notifications").to route_to("bell/notifications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bell/notifications/1").to route_to("bell/notifications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bell/notifications/1").to route_to("bell/notifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bell/notifications/1").to route_to("bell/notifications#destroy", :id => "1")
    end
  end
end
