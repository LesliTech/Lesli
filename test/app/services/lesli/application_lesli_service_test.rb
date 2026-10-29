require "test_helper"

module Lesli
    class ApplicationLesliServiceTest < ActiveSupport::TestCase
        class ExampleService < Lesli::ApplicationLesliService
            def succeed_with(resource)
                response(resource)
            end

            def fail_with(message)
                error(message)
                self
            end
        end

        test "requires the service context" do
            assert_raises(ArgumentError) do
                ExampleService.new
            end
        end

        test "starts with an empty successful response" do
            query = { pagination: { page: 1 } }
            service = ExampleService.new(Object.new, query)

            assert service.successful?
            assert_nil service.result
            assert_empty service.errors
            assert_same query, service.query
        end

        test "find stores and clears the current result" do
            service = ExampleService.new(Object.new)

            assert_same service, service.find(:record)
            assert_predicate service, :found?
            assert_equal :record, service.result

            service.find(nil)

            refute_predicate service, :found?
            assert_nil service.result
        end

        test "response stores a result and returns the service" do
            service = ExampleService.new(Object.new)

            assert_same service, service.succeed_with(:record)
            assert_equal :record, service.result
        end

        test "errors determine whether the operation was successful" do
            service = ExampleService.new(Object.new)

            assert_same service, service.fail_with("First failure")
            refute_predicate service, :successful?
            assert_equal ["First failure"], service.errors
            assert_equal "First failure", service.errors_as_sentence
        end

        test "does not silently implement CRUD operations" do
            service = ExampleService.new(Object.new)

            assert_raises(NoMethodError) do
                service.index
            end
        end
    end
end
