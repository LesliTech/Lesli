require "rails_helper"

RSpec.describe Role::DescriptorAssignmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/role/descriptor_assignments").to route_to("role/descriptor_assignments#index")
    end

    it "routes to #new" do
      expect(get: "/role/descriptor_assignments/new").to route_to("role/descriptor_assignments#new")
    end

    it "routes to #show" do
      expect(get: "/role/descriptor_assignments/1").to route_to("role/descriptor_assignments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/role/descriptor_assignments/1/edit").to route_to("role/descriptor_assignments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/role/descriptor_assignments").to route_to("role/descriptor_assignments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/role/descriptor_assignments/1").to route_to("role/descriptor_assignments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/role/descriptor_assignments/1").to route_to("role/descriptor_assignments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/role/descriptor_assignments/1").to route_to("role/descriptor_assignments#destroy", id: "1")
    end
  end
end
