require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class HtmlHelperTest < LesliViewTester

        attr_accessor :controller_path, :action_name

        setup do
            @controller_path = "lesli_dashboard"
            @action_name = "index"
        end

        test "lesli_favicon prints three link tags" do
            html = lesli_favicon

            assert_includes html, 'rel="alternate icon"'
            assert_includes html, 'rel="icon"'
            assert_includes html, 'rel="mask-icon"'
        end

        test "lesli_website_title uses controller and action" do
            original = Lesli.config.company
            Lesli.config.company = { name: "Lesli Inc" }

            @controller_path = "lesli_dashboard"
            @action_name = "show"

            title = lesli_website_title

            assert_equal "dashboard/show · Lesli Inc", title
        ensure
            Lesli.config.company = original
        end

        test "lesli_website_title ignores index action" do
            original = Lesli.config.company
            Lesli.config.company = { name: "Lesli Inc" }

            @controller_path = "lesli_dashboard"
            @action_name = "index"

            title = lesli_website_title

            assert_equal "dashboard · Lesli Inc", title
        ensure
            Lesli.config.company = original
        end

        test "lesli_website_title uses custom title if provided" do
            original = Lesli.config.company
            Lesli.config.company = { name: "Lesli Inc" }

            @application_html_title = "Custom Title"
            @action_name = "index"

            title = lesli_website_title

            assert_equal "Custom Title · Lesli Inc", title
        ensure
            Lesli.config.company = original
        end

        test "lesli_website_meta_description returns empty string by default" do
            @application_html_description = nil
            assert_equal "", lesli_website_meta_description
        end

        test "lesli_website_meta_description returns custom description" do
            @application_html_description = "Test description"
            assert_equal "Test description", lesli_website_meta_description
        end

        test "lesli_application_body_class builds correct class string" do
            @controller_path = "users/profile"
            @action_name = "edit"

            body_class = lesli_application_body_class

            assert_includes body_class, "lesli"
            assert_includes body_class, "users"
            assert_includes body_class, "profile"
            assert_includes body_class, "edit"
        end

        # test "lesli_stylesheet_path returns application for root engine" do
        #     original = LesliSystem.method(:engine)

        #     LesliSystem.define_singleton_method(:engine) do |*args|
        #         "root"
        #     end

        #     assert_equal "application", lesli_stylesheet_path
        # ensure
        #     LesliSystem.define_singleton_method(:engine, original)
        # end

        # test "lesli_stylesheet_path returns engine stylesheet" do
        #     original = LesliSystem.method(:engine)

        #     LesliSystem.define_singleton_method(:engine) do |*args|
        #         "lesli_support"
        #     end

        #     assert_equal "lesli_support/application", lesli_stylesheet_path
        # ensure
        #     LesliSystem.define_singleton_method(:engine, original)
        # end

        test "lesli_stylesheet_path returns explicit engine stylesheet" do
            assert_equal "lesli/application", lesli_stylesheet_path(:lesli, "application")
        end

        test "lesli_svg renders svg with use tag" do
            html = lesli_svg("test-icon")

            assert_includes html, "<svg"
            assert_includes html, "use"
            assert_includes html, "test-icon"
        end

        test "dd prints formatted json" do
            object = { name: "Luis" }
            html = dd(object)

            assert_includes html, "<pre"
            assert_includes html, "<code"
            assert_includes html, "Luis"
        end
    end
end
