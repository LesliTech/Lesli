require "test_helper"

module Lesli
    class ResourceOperatorTest < ActiveSupport::TestCase
        test "registration preserves IDs and does not duplicate actions" do
            operator = ResourceOperator.new
            operator.define_singleton_method(:routes_by_engine) do
                { "example" => { "example/tickets" => %w[index show show] } }
            end

            operator.register!
            controller = Resource.find_by!(route: "example/tickets")
            assert_equal %w[index show], controller.children.order(:action).pluck(:action)
            assert_equal "Example::Tickets", controller.identifier
            ids = controller.children.order(:id).pluck(:id)

            assert_no_difference -> { Resource.count } do
                operator.register!
            end
            assert_equal ids, controller.children.order(:id).pluck(:id)
        end

        test "a failed registration rolls back earlier resources" do
            operator = ResourceOperator.new
            operator.define_singleton_method(:routes_by_engine) do
                { "example" => { "example/first" => ["index"], "example/second" => [nil] } }
            end

            assert_no_difference -> { Resource.count } do
                assert_raises(NoMethodError) { operator.register! }
            end
        end

        test "real route scanning produces an indexable resource catalog" do
            ResourceOperator.new.register!
            matrix = ResourceService.new(nil).index(matrix: true)
            assert_includes matrix.fetch("lesli"), "Lesli::Apps"
            assert matrix["lesli"]["Lesli::Apps"][:actions].any? { |action| action[:action] == "show" }
        end
    end
end
