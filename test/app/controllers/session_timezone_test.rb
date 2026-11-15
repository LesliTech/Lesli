require "test_helper"

module Lesli
    class SessionTimezoneTest < ActionController::TestCase
        class PageController < Lesli::ApplicationLesliController
            skip_before_action :set_locale, :set_customizer, :set_requester, :load_announcements
            skip_before_action :authenticate_request, :authorize_request, raise: false
            skip_after_action :log_requests, raise: false

            def show
                render json: { date: LesliDate::Formatter.new("2027-01-15 15:00:00").date_time.to_s }
            end
        end

        tests PageController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw { get "page", to: "lesli/session_timezone_test/page#show" }
            @previous_datetime = Lesli.config.datetime
            Lesli.config.datetime = { time_zone: "America/Guatemala" }
        end

        teardown do
            Lesli.config.datetime = @previous_datetime
        end

        test "date formatting uses the session zone and restores the previous zone" do
            session[:time_zone] = "Europe/Berlin"
            Time.use_zone("UTC") do
                get :show
                assert_response :success
                assert_equal "15.01.2027 16:00", response.parsed_body.fetch("date")
                assert_equal "UTC", Time.zone.name
            end
        end

        test "missing and invalid session zones use the global fallback" do
            [nil, "Invalid/Timezone"].each do |zone|
                session[:time_zone] = zone
                get :show
                assert_response :success
                assert_equal "15.01.2027 09:00", response.parsed_body.fetch("date")
            end
        end
    end
end
