require "test_helper"

module Lesli
    class ApplicationPartialsTest < LesliTesting::ViewTester
        test "header integration supplies branding and available actions" do
            @lesli = { notifications: 105 }
            def view.navigation_partial
                nil
            end
            def view.application_dashboard_path
                "/dashboard"
            end
            def view.customization_instance_logo_tag(**)
                tag.img(src: "/logo.svg", alt: "Brand")
            end
            def view.current_page?(path)
                path == lesli.apps_path
            end

            render partial: "lesli/partials/application-lesli-header"

            assert_select '.lesli-application-header-logo-link[href="/dashboard"] img[alt="Brand"]'
            assert_select 'a[aria-current="page"]', count: 1
            assert_select ".lesli-application-header-navigation", count: 0
            if defined?(LesliBell)
                assert_select ".lesli-application-header-count", text: "99+"
            end
            if defined?(LesliShield)
                assert_select "a[href=?]", view.main_app.destroy_user_session_path
            end
        end

        test "flash integration renders and discards messages while keeping the Turbo target" do
            messages = ActionDispatch::Flash::FlashHash.new
            messages[:notice] = "Saved"
            view.define_singleton_method(:flash) { messages }

            render partial: "lesli/partials/application-lesli-notifications"

            assert_select "#application-lesli-notifications .is-success", text: "Saved"
            assert_nil messages.to_session_value
        end
    end
end
