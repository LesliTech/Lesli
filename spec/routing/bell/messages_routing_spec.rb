require "rails_helper"

RSpec.describe Bell::MessagesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/bell/messages").to route_to("bell/messages#index")
    end

    it "routes to #new" do
      expect(:get => "/bell/messages/new").to route_to("bell/messages#new")
    end

    it "routes to #show" do
      expect(:get => "/bell/messages/1").to route_to("bell/messages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bell/messages/1/edit").to route_to("bell/messages#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/bell/messages").to route_to("bell/messages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bell/messages/1").to route_to("bell/messages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bell/messages/1").to route_to("bell/messages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bell/messages/1").to route_to("bell/messages#destroy", :id => "1")
    end
  end
end
