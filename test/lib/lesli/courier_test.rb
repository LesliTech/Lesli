
require Lesli::Engine.root.join("lib/test/lesli") 

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


module Lesli
    class CourierTest < ActiveSupport::TestCase

        def setup
            @courier_with_params =
                Lesli::Courier.new(:lesli_courier_test_module, "Error occurred")
                .from(:courier_test_service, "my params")

            @courier_without_params =
                Lesli::Courier.new(:lesli_courier_test_module, "Error occurred")
                .from(:courier_test_service)

            @courier_with_invalid_module =
                Lesli::Courier.new(:invalid_module, "Module not found")
                .from(:courier_test_service)

            @courier_with_invalid_service =
                Lesli::Courier.new(:lesli_courier_test_module, "Service not found")
                .from(:invalid_service)

            @courier_without_custom_error =
                Lesli::Courier.new(:lesli_courier_test_module)
                .from(:courier_test_service)
        end

        # Valid module, service, method
        test "calls the service method with params" do
            result = @courier_with_params.call(:lesli_courier_test_method)
            assert_equal "Processing ticket with params: my params", result
        end

        test "calls the service method without params" do
            result = @courier_without_params.call(:lesli_courier_test_method)
            assert_equal "Processing ticket without params", result
        end

        # Invalid module
        test "returns error when module does not exist" do
            result = @courier_with_invalid_module.call(:lesli_courier_test_method)
            assert_equal "Module not found", result
        end

        # Invalid service class
        test "returns error when service class does not exist" do
            result = @courier_with_invalid_service.call(:lesli_courier_test_method)
            assert_equal "Service not found", result
        end

        # Invalid method
        test "returns generic error when method does not exist" do
            result = @courier_without_params.call(:non_existent_method)
            assert_equal "Error occurred", result
        end
    end
end
