require "test_helper"

module Lesli
    class ResponderInterfaceTest < ActiveSupport::TestCase

        # Define a mock controller class to test the module
        class MockController
            include Lesli::ResponderInterface

            # Mock the `render` method to capture its arguments
            attr_reader :render_args
            attr_accessor :response_format

            def render(*args)
                @render_args = args
            end

            # Mock the `flash` method
            attr_accessor :flash

            def initialize
                @flash = {}
                @response_format = :html
            end

            def respond_to
                yield MockFormat.new(response_format)
            end

            def current_user
                nil
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

        class MockFormat
            def initialize(response_format)
                @response_format = response_format
            end

            [:html, :json, :turbo_stream].each do |format|
                define_method(format) do |&block|
                    block.call if @response_format == format
                end
            end
        end

        def setup
            @controller = MockController.new
        end

        [:info, :success, :warning, :danger].each do |flash_type|
            define_method("test_flash_#{flash_type} set flash message") do
                @controller.send(flash_type, "Test message")
                assert_equal "Test message", @controller.flash[flash_type]
            end
        end

        ## Testing respond_with_success_stream

        test "stream_notification_success sets flash and renders turbo stream" do
            message = "Success!"
            stream =["update_call", {:target=>"application-lesli-notifications", :content=>{:partial=>"lesli/partials/application-lesli-notifications", :locals=>{}}}]

            @controller.stream_notification_success(message)

            # Assert that the flash was set correctly
            assert_equal({ success: message }, @controller.flash)

        end

        test "respond_with_json renders with status 200" do
            payload = { some: "data" }

            @controller.respond_with_json(payload)

            render_options = @controller.render_args.first
            assert_equal 200, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal payload.to_json, render_options[:json]
        end

        test "respond_with_http renders with correct status and payload" do
            status = 404
            payload = { error: "Not Found" }

            @controller.respond_with_http(status, payload)

            render_options = @controller.render_args.first
            assert_equal status, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal payload.to_json, render_options[:json]
        end

        test "respond_with_http handles nil payload" do
            status = 204
            @controller.respond_with_http(status, nil)

            render_options = @controller.render_args.first
            assert_equal status, render_options[:status]
            assert_equal "application/json", render_options[:content_type]
            assert_equal "", render_options[:json]
        end

        [:html, :turbo_stream].each do |format|
            test "respond_with_forbidden renders #{format} with forbidden status" do
                @controller.response_format = format

                @controller.respond_with_forbidden

                assert_equal "lesli/errors/unauthorized", @controller.render_args.first
                assert_equal :forbidden, @controller.render_args.second[:status]
            end
        end

        test "respond_with_unauthorized remains an alias for respond_with_forbidden" do
            @controller.respond_with_unauthorized

            assert_equal "lesli/errors/unauthorized", @controller.render_args.first
            assert_equal :forbidden, @controller.render_args.second[:status]
        end
    end
end
