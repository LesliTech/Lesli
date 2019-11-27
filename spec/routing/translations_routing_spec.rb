require "rails_helper"

RSpec.describe TranslationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/translations").to route_to("translations#index")
    end

    it "routes to #new" do
      expect(:get => "/translations/new").to route_to("translations#new")
    end

    it "routes to #show" do
      expect(:get => "/translations/1").to route_to("translations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/translations/1/edit").to route_to("translations#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/translations").to route_to("translations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/translations/1").to route_to("translations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/translations/1").to route_to("translations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/translations/1").to route_to("translations#destroy", :id => "1")
    end
  end
end
