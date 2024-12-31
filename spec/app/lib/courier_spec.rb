# spec/lesli_courier_spec.rb

require "rails_helper"
require Lesli::Engine.root.join("lib/rspec/testers/model")

RSpec.describe Lesli::Courier, type: :model do
    before(:all) do

        # Define a mock service class inside the new module LesliCourierTestModule
        module LesliCourierTestModule
            class CourierTestService
                def initialize(params = nil)
                    @params = params
                end

                def lesli_courier_test_method
                    if @params
                        "Processing ticket with params: #{@params}"
                    else
                        "Processing ticket without params"
                    end
                end
            end
        end
    end

    # Define courier instances with the new module and service name
    let(:courier_with_params) { Lesli::Courier.new(:lesli_courier_test_module, "Error occurred").from(:courier_test_service, "my params") }
    let(:courier_without_params) { Lesli::Courier.new(:lesli_courier_test_module, "Error occurred").from(:courier_test_service) }
    let(:courier_with_invalid_module) { Lesli::Courier.new(:invalid_module, "Module not found").from(:courier_test_service) }
    let(:courier_with_invalid_service) { Lesli::Courier.new(:lesli_courier_test_module, "Service not found").from(:invalid_service) }

    context "when the module, service, and method exist" do

        it "calls the service method with params" do
            expect(courier_with_params.call(:lesli_courier_test_method))
            .to eq("Processing ticket with params: my params")
        end

        it "calls the service method without params" do
            expect(courier_without_params.call(:lesli_courier_test_method))
            .to eq("Processing ticket without params")
        end
    end

    context "when the module does not exist" do
        it "returns the error message" do
            expect(courier_with_invalid_module.call(:lesli_courier_test_method))
            .to eq("Module not found")
        end
    end

    context "when the service class does not exist" do
        it "returns the error message" do
            expect(courier_with_invalid_service.call(:lesli_courier_test_method))
            .to eq("Service not found")
        end
    end

    context "when the method does not exist on the service class" do
        it "raises a NoMethodError" do
            expect(courier_without_params.call(:non_existent_method))
            .to eq("Error occurred")
        end
    end
end
