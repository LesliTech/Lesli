
require "test_helper"

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

        def fail_during_execution
            raise "Service execution failed"
        end

        private

        def private_method
            "Not public"
        end
    end

    class CourierKeywordService
        def initialize(value:, suffix:)
            @value = value
            @suffix = suffix
        end

        def format(prefix:)
            "#{prefix} #{@value}#{@suffix}"
        end
    end
end

class LesliCourierTestErrorReporter
    attr_reader :error, :options

    def report(error, **options)
        @error = error
        @options = options
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

        # An installed module has a defined contract. Programming errors must remain visible.
        test "raises when service class does not exist in an installed module" do
            assert_raises(NameError) do
                @courier_with_invalid_service.call(:lesli_courier_test_method)
            end
        end

        # Invalid method
        test "raises when method does not exist in an installed service" do
            assert_raises(NoMethodError) do
                @courier_without_params.call(:non_existent_method)
            end
        end

        test "raises when method is not public" do
            assert_raises(NoMethodError) do
                @courier_without_params.call(:private_method)
            end
        end

        test "forwards keyword arguments to the constructor and method" do
            result = Lesli::Courier
                .new(:lesli_courier_test_module)
                .from(:courier_keyword_service, value: "ticket", suffix: "!")
                .call(:format, prefix: "Created")

            assert_equal "Created ticket!", result
        end

        test "does not hide errors raised by an installed service" do
            error = assert_raises(RuntimeError) do
                @courier_without_params.call(:fail_during_execution)
            end

            assert_equal "Service execution failed", error.message
        end

        test "reports errors and returns fallback when fallback_on_error is enabled" do
            reporter = LesliCourierTestErrorReporter.new
            courier = Lesli::Courier
                .new(
                    :lesli_courier_test_module,
                    "Integration unavailable",
                    fallback_on_error: true
                )
                .from(:courier_test_service)

            Rails.error.subscribe(reporter)

            begin
                result = courier.call(:fail_during_execution)
            ensure
                Rails.error.unsubscribe(reporter)
            end

            assert_equal "Integration unavailable", result
            assert_equal "Service execution failed", reporter.error.message
            assert_equal true, reporter.options[:handled]
            assert_equal(
                {
                    module_name: "LesliCourierTestModule",
                    service_name: "CourierTestService",
                    method_name: :fail_during_execution
                },
                reporter.options[:context]
            )
        end

    end
end
