require "rails_helper"

RSpec.describe CustomFieldsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/custom_fields").to route_to("custom_fields#index")
    end

    it "routes to #new" do
      expect(:get => "/custom_fields/new").to route_to("custom_fields#new")
    end

    it "routes to #show" do
      expect(:get => "/custom_fields/1").to route_to("custom_fields#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/custom_fields/1/edit").to route_to("custom_fields#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/custom_fields").to route_to("custom_fields#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/custom_fields/1").to route_to("custom_fields#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/custom_fields/1").to route_to("custom_fields#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/custom_fields/1").to route_to("custom_fields#destroy", :id => "1")
    end
  end
end
