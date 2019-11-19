require "rails_helper"

RSpec.describe Bell::EmailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/bell/emails").to route_to("bell/emails#index")
    end

    it "routes to #new" do
      expect(:get => "/bell/emails/new").to route_to("bell/emails#new")
    end

    it "routes to #show" do
      expect(:get => "/bell/emails/1").to route_to("bell/emails#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bell/emails/1/edit").to route_to("bell/emails#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/bell/emails").to route_to("bell/emails#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bell/emails/1").to route_to("bell/emails#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bell/emails/1").to route_to("bell/emails#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bell/emails/1").to route_to("bell/emails#destroy", :id => "1")
    end
  end
end
