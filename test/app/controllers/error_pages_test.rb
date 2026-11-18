require "test_helper"

module Lesli
    class ErrorPagesTest < ActionController::TestCase
        # Exercise Core's templates and HTTP responses without authentication setup.
        class PageController < ActionController::Base
            append_view_path Lesli::Engine.root.join("app/views")

            def forbidden
                @error_object = {
                    error_details: { controller: "tickets", action: "edit" },
                    error_role: "<script>Administrator</script>"
                }
                render template: "lesli/errors/unauthorized", status: :forbidden
            end

            def missing
                @message = "<script>Missing resource</script>"
                render template: "lesli/errors/not_found", status: :not_found
            end
        end

        tests PageController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw do
                get "forbidden", to: "lesli/error_pages_test/page#forbidden"
                get "missing", to: "lesli/error_pages_test/page#missing"
            end
        end

        test "forbidden keeps translated messages Core details and status" do
            get :forbidden

            assert_response :forbidden
            assert_select "turbo-frame#accounts"
            assert_select "#unauthorized-title", text: "403 #{I18n.t('lesli.shared.message_error_unauthorized')}"
            assert_select ".lesli-error-message", text: I18n.t("lesli.shared.message_error_unauthorized_credentials").strip
            assert_select ".lesli-error-icon", text: "shield_lock"
            assert_select ".lesli-error-details li", count: 2
            assert_select "script", count: 0
            assert_includes response.body, "&lt;script&gt;Administrator&lt;/script&gt;"
        end

        test "not found keeps the existing illustration message and status" do
            get :missing

            assert_response :not_found
            assert_select "#not-found-title", text: "404 #{I18n.t('lesli.shared.message_error_not_found')}"
            assert_select ".lesli-empty-state svg"
            assert_select ".lesli-error-message", text: "<script>Missing resource</script>"
            assert_select ".lesli-error-details", count: 0
            assert_select "script", count: 0
        end
    end
end
