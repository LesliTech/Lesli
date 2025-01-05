# spec/lesli_courier_spec.rb

require "rails_helper"
require Lesli::Engine.root.join("lib/rspec/testers/model")

RSpec.describe Lesli::ApplicationLesliService do
    let(:current_user) { double("User", account: double("Account")) }
    let(:query) { { some_param: "value" } }
    let(:service) { described_class.new(current_user, query) }

    describe "#initialize" do
        it "sets the current_user" do
            expect(service.instance_variable_get(:@current_user)).to eq(current_user)
        end

        it "sets the query" do
            expect(service.instance_variable_get(:@query)).to eq(query)
        end

        it "initializes resource to nil" do
            expect(service.instance_variable_get(:@resource)).to be_nil
        end

        it "initializes failures to an empty array" do
            expect(service.instance_variable_get(:@failures)).to eq([])
        end
    end

    describe "#find" do
        let(:resource) { double("Resource") }

        it "assigns the provided resource to @resource" do
            service.find(resource)
            expect(service.result).to eq(resource)
        end

        it "returns self" do
            expect(service.find(resource)).to eq(service)
        end
    end

    describe "#create" do
        let(:resource) { double("Resource") }

        it "assigns the provided resource to @resource" do
            service.create(resource)
            expect(service.result).to eq(resource)
        end

        it "returns self" do
            expect(service.create(resource)).to eq(service)
        end
    end

    describe "#found?" do
        context "when resource is not nil" do
            it "returns true" do
                service.find(double("Resource"))
                expect(service.found?).to be true
            end
        end

        context "when resource is nil" do
            it "returns false" do
                expect(service.found?).to be false
            end
        end
    end

    describe "#successful?" do
        context "when there are no failures" do
            it "returns true" do
                expect(service.successful?).to be true
            end
        end

        context "when there are failures" do
            it "returns false" do
                service.error("Something went wrong")
                expect(service.successful?).to be false
            end
        end
    end

    describe "#errors" do
        it "returns the list of failures" do
            service.error("Error 1")
            service.error("Error 2")
            expect(service.errors).to eq(["Error 1", "Error 2"])
        end
    end

    describe "#errors_as_sentence" do
        it "returns the failures as a single string" do
            service.error("Error 1")
            service.error("Error 2")
            expect(service.errors_as_sentence).to eq("Error 1 and Error 2")
        end
    end

    describe "#error" do
        it "adds a new error to the failures list" do
            service.error("New Error")
            expect(service.errors).to include("New Error")
        end
    end

    describe "#result" do
        it "returns the current resource" do
            resource = double("Resource")
            service.find(resource)
            expect(service.result).to eq(resource)
        end
    end
end
