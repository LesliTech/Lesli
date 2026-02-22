require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class NavigationHelperTest < LesliViewTester

        attr_accessor :controller_path, :action_name, :lookup_context

        setup do
            @controller_path = "lesli_dashboard"
            @action_name = "index"

            # Fake lookup context
            @lookup_context = Object.new
        end

        # ----------------------------
        # navigation_partial
        # ----------------------------

        # test "navigation_partial returns path when partial exists" do
        #     original = LesliSystem.method(:engine)

        #     LesliSystem.define_singleton_method(:engine) do |*args|
        #         { code: "root" }
        #     end

        #     def lookup_context.exists?(*)
        #         true
        #     end

        #     assert_equal "partials/navigation", navigation_partial
        # ensure
        #     LesliSystem.define_singleton_method(:engine, original)
        # end

        # test "navigation_partial returns nil when partial does not exist" do
        #     original = LesliSystem.method(:engine)

        #     LesliSystem.define_singleton_method(:engine) do |*args|
        #         { code: "root" }
        #     end

        #     def lookup_context.exists?(*)
        #         false
        #     end

        #     assert_nil navigation_partial
        # ensure
        #     LesliSystem.define_singleton_method(:engine, original)
        # end

        # ----------------------------
        # navigation_separator
        # ----------------------------

        test "navigation_separator renders li with hr" do
            html = navigation_separator

            assert_includes html, "<li"
            assert_includes html, "<hr"
        end

        # ----------------------------
        # navigation_link
        # ----------------------------

        test "navigation_link renders text-only link" do
            html = navigation_link("/test", "Dashboard")

            assert_includes html, "Dashboard"
            assert_includes html, "/test"
        end

        test "navigation_link renders link with icon" do
            html = navigation_link("/test", "Dashboard", "icon-home")

            assert_includes html, "icon-home"
            assert_includes html, "Dashboard"
        end

        # ----------------------------
        # navigation_item
        # ----------------------------

        test "navigation_item wraps link in li" do
            html = navigation_item("/test", "Dashboard")

            assert_includes html, "<li"
            assert_includes html, "Dashboard"
        end

        # ----------------------------
        # navigation_engine_item (private)
        # ----------------------------

        test "navigation_engine_item renders active item" do
            html = send(
                :navigation_engine_item,
                "Admin",
                "Admin area",
                "admin",
                "/admin",
                true
            )

            assert_includes html, "Admin"
            assert_includes html, "Admin area"
            assert_includes html, "is-active"
        end

        test "navigation_engine_item renders inactive item" do
            html = send(
                :navigation_engine_item,
                "Admin",
                "Admin area",
                "admin",
                "/admin",
                false
            )

            assert_includes html, "Admin"
            refute_includes html, "is-active"
        end
    end
end
