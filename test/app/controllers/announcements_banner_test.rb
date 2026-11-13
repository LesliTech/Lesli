require "test_helper"

module Lesli
    class AnnouncementsBannerTest < ActionController::TestCase
        class PageController < ApplicationLesliController
            skip_before_action :set_locale, :set_customizer, :set_requester
            skip_before_action :authenticate_request, :authorize_request, raise: false
            skip_after_action :log_requests, raise: false
            layout false

            def show
                render partial: "lesli/partials/application-lesli-announcements"
            end
        end

        tests PageController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw { get "page", to: "lesli/announcements_banner_test/page#show" }
        end

        test "Core renders an empty banner area without LesliBell" do
            @controller.define_singleton_method(:current_user) { Object.new }
            bell = Object.send(:remove_const, :LesliBell) if Object.const_defined?(:LesliBell)
            get :show
            assert_response :success
            assert_select "#application-lesli-announcements", count: 0
            assert_equal false, @controller.instance_variable_get(:@lesli_announcements_enabled)
        ensure
            Object.const_set(:LesliBell, bell) if bell
        end

        test "anonymous requests do not query announcements" do
            @controller.define_singleton_method(:current_user) { nil }
            get :show
            assert_response :success
            assert_select "#application-lesli-announcements", count: 0
        end
    end
end
