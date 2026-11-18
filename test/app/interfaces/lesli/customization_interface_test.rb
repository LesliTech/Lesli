require "test_helper"
require "active_support/testing/constant_stubbing"

module Lesli
    class CustomizationInterfaceTest < ActiveSupport::TestCase
        include ActiveSupport::Testing::ConstantStubbing

        class Page
            include Lesli::CustomizationInterface
            attr_reader :request, :lesli
            attr_accessor :current_user

            def initialize(user = nil, format: :html)
                @current_user = user
                @request = Struct.new(:format).new(Mime[format])
                @lesli = { customization: { logos: { app: "/logo.svg" } } }
            end
        end

        test "loads only the current account setting without replacing other customization" do
            with_admin do
                first = page_with_color("#7C3AED")
                second = page_with_color("#123")
                first.set_customizer
                second.set_customizer
                turbo = page_with_color("#7C3AED")
                turbo.request.format = Mime[:turbo_stream]
                turbo.set_customizer
                assert_equal "#7C3AED", turbo.lesli.dig(:customization, :colors, :lesli_theme_color_primary)

                assert_equal "#7C3AED", first.lesli.dig(:customization, :colors, :lesli_theme_color_primary)
                assert_equal "#123", second.lesli.dig(:customization, :colors, :lesli_theme_color_primary)
                assert_equal "/logo.svg", first.lesli.dig(:customization, :logos, :app)
            end
        end

        test "missing blank and invalid colors leave the CSS fallback intact" do
            with_admin do
                [nil, "", " ", "red", "#12345", "#fff; color: red"].each do |color|
                    page = page_with_color(color)
                    page.set_customizer
                    assert_nil page.lesli.dig(:customization, :colors)
                end
                page = Page.new(Struct.new(:account).new(Struct.new(:admin).new(nil)))
                page.set_customizer
                assert_nil page.lesli.dig(:customization, :colors)
            end
        end

        test "anonymous and non-page requests need no account" do
            with_admin do
                [Page.new, Page.new(Object.new, format: :json)].each do |page|
                    page.set_customizer
                    assert_nil page.lesli.dig(:customization, :colors)
                end
            end
        end

        test "core works without the optional administration engine" do
            # Run in an isolated Ruby process so installed engine constants are untouched.
            source = Lesli::Engine.root.join("app/interfaces/lesli/customization_interface.rb")
            script = <<~RUBY_SCRIPT
                require #{source.to_s.inspect}
                page = Object.new.extend(Lesli::CustomizationInterface)
                format = Object.new
                def format.html?; true; end
                page.define_singleton_method(:request) { Struct.new(:format).new(format) }
                page.set_customizer
            RUBY_SCRIPT
            require "open3"
            output, status = Open3.capture2e(RbConfig.ruby, "-e", script)
            assert status.success?, output
        end

        private

        def with_admin(&block)
            if defined?(LesliAdmin)
                yield
            else
                stub_const(Object, :LesliAdmin, Module.new, exists: false, &block)
            end
        end

        def page_with_color(color)
            test = self
            settings = Object.new
            settings.define_singleton_method(:where) do |**conditions|
                test.assert_equal({ name: "lesli_theme_color_primary", user_id: nil }, conditions)
                self
            end
            settings.define_singleton_method(:pick) do |column|
                test.assert_equal :value, column
                color
            end
            account = Struct.new(:admin).new(Struct.new(:settings).new(settings))
            Page.new(Struct.new(:account).new(account))
        end
    end
end
