require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class ResponderInterfaceTest < ActiveSupport::TestCase

        # Define a mock controller class to test the module
        class MockController
            include Lesli::ResponderInterface

            # Mock the `render` method to capture its arguments
            attr_reader :render_args

            def render(*args)
                @render_args = args
            end

            # Mock the `flash` method
            attr_accessor :flash

            def initialize
                @flash = {}
            end

            # Corrected: Create a proper mock for `turbo_stream`
            def turbo_stream
                MockTurboStream.new
            end
        end

        # Define a mock TurboStream class that responds to `update`
        class MockTurboStream
            def update(*args)
                # Return a mock representation of the turbo_stream.update call
                { "update_call" => { target: args[0], content: args[1] } }
            end
        end

        def setup
            @controller = MockController.new
        end

        ## Testing respond_with_success_stream

        test "#respond_with_success_stream sets flash and renders turbo stream" do
            message = "Success!"
            stream = {"update_call"=>{:target=>"application-lesli-notifications", :content=>{:partial=>"lesli/partials/application-lesli-notifications"}}}

            @controller.respond_with_success_stream(message, stream)

            # Assert that the flash was set correctly
            assert_equal({ success: message }, @controller.flash)

            # Assert that `render` was called with the correct arguments
            render_options = @controller.render_args.first

            # The turbo_stream array should have two elements
            assert_equal 1, render_options[:turbo_stream].size

            # The first element should be the update call with the correct partial
            update_call = render_options[:turbo_stream].first
            assert_equal "application-lesli-notifications", update_call["update_call"][:target]
            assert_equal ({ partial: "lesli/partials/application-lesli-notifications" }), update_call["update_call"][:content]

            # The second element should be the provided stream
            assert_equal stream, render_options[:turbo_stream].first
        end

        test "#respond_with_success_json renders with status 200" do
            payload = { some: "data" }

            @controller.respond_with_success_json(payload)

            render_options = @controller.render_args.first
            assert_equal 200, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal payload.to_json, render_options[:json]
        end

        test "#respond_with_http renders with correct status and payload" do
            status = 404
            payload = { error: "Not Found" }

            @controller.respond_with_http(status, payload)

            render_options = @controller.render_args.first
            assert_equal status, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal payload.to_json, render_options[:json]
        end

        test "#respond_with_http handles nil payload" do
            status = 204
            @controller.respond_with_http(status, nil)

            render_options = @controller.render_args.first
            assert_equal status, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal "", render_options[:json]
        end
    end
end
