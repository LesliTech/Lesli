require "test_helper"

module Lesli
    class ResponderInterfaceTest < ActiveSupport::TestCase

        # Define a mock controller class to test the module
        class MockController
            include Lesli::ResponderInterface

            # Mock the `render` method to capture its arguments
            attr_reader :render_args
            attr_reader :redirect_args
            attr_reader :head_status
            attr_accessor :response_format

            def render(*args)
                @render_args = args
            end

            def redirect_to(*args)
                @redirect_args = args
            end

            def head(status)
                @head_status = status
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
            assert_equal :ok, render_options[:status]
            assert_equal payload, render_options[:json]
        end

        test "respond_with_lesli renders an explicit html template and status" do
            @controller.respond_with_lesli(
                html: "lesli/examples/show",
                status: :created
            )

            assert_equal "lesli/examples/show", @controller.render_args.first
            assert_equal :created, @controller.render_args.second[:status]
        end

        test "respond_with_lesli renders the current html template when html is omitted" do
            @controller.respond_with_lesli(json: { status: "ok" })

            assert_equal({ status: :ok }, @controller.render_args.first)
        end

        test "respond_with_lesli redirects html with see other by default" do
            @controller.respond_with_lesli(redirect: "/examples/1")

            assert_equal "/examples/1", @controller.redirect_args.first
            assert_equal :see_other, @controller.redirect_args.second[:status]
            assert_nil @controller.render_args
        end

        test "respond_with_lesli supports a custom redirect status" do
            @controller.respond_with_lesli(
                redirect: "/examples/1",
                redirect_status: :temporary_redirect
            )

            assert_equal :temporary_redirect, @controller.redirect_args.second[:status]
        end

        test "respond_with_lesli rejects html and redirect together" do
            error = assert_raises(ArgumentError) do
                @controller.respond_with_lesli(
                    html: "lesli/examples/show",
                    redirect: "/examples/1"
                )
            end

            assert_equal "Use either html: or redirect:, not both", error.message
        end

        test "respond_with_lesli applies status to json responses" do
            @controller.response_format = :json

            @controller.respond_with_lesli(
                json: { id: 1 },
                status: :created
            )

            render_options = @controller.render_args.first
            assert_equal :created, render_options[:status]
            assert_equal({ id: 1 }, render_options[:json])
        end

        test "respond_with_lesli applies status to turbo stream responses" do
            @controller.response_format = :turbo_stream
            stream = { action: "update" }

            @controller.respond_with_lesli(
                turbo: stream,
                status: :unprocessable_entity
            )

            render_options = @controller.render_args.first
            assert_equal stream, render_options[:turbo_stream]
            assert_equal :unprocessable_entity, render_options[:status]
        end

        test "respond_with_http renders with correct status and payload" do
            status = 404
            payload = { error: "Not Found" }

            @controller.respond_with_http(status, payload)

            render_options = @controller.render_args.first
            assert_equal status, render_options[:status]
            assert_equal payload, render_options[:json]
        end

        test "respond_with_http handles nil payload" do
            status = 204
            @controller.respond_with_http(status, nil)

            assert_equal status, @controller.head_status
            assert_nil @controller.render_args
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
