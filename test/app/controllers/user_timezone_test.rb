require "test_helper"

module Lesli
    class UserTimezoneTest < ActionController::TestCase
        class DateService < Lesli::ApplicationLesliService
            def show
                response(Date2.new("2027-01-15 15:00:00", zone: current_user&.effective_time_zone).date_time.to_s)
            end
        end

        class PageController < Lesli::ApplicationLesliController
            skip_before_action :set_locale, :set_customizer, :set_requester, :load_announcements
            skip_before_action :authenticate_request, :authorize_request, raise: false
            skip_after_action :log_requests, raise: false

            def show
                user = current_user if respond_to?(:current_user, true)
                render json: {
                    date: LesliDate::Formatter.new("2027-01-15 15:00:00", zone: user&.effective_time_zone).date_time.to_s,
                    rails_zone: Time.zone.name
                }
            end

            def detail
                @zone = current_user.effective_time_zone
                @date = DateService.new(current_user).show.result
                render inline: '<p><%= @date %></p><time><%= Date2.new("2027-01-15 15:00:00", zone: @zone).date_time.to_s %></time>', layout: false
            end

            def failure
                raise "Rendering failed"
            end
        end

        tests PageController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw do
                get "page", to: "lesli/user_timezone_test/page#show"
                get "detail", to: "lesli/user_timezone_test/page#detail"
                get "failure", to: "lesli/user_timezone_test/page#failure"
            end
            @previous_datetime = Lesli.config.datetime
            Lesli.config.datetime = { time_zone: "America/Guatemala" }
        end

        teardown do
            Lesli.config.datetime = @previous_datetime
        end

        test "explicit profile formatting does not change the Rails zone" do
            user = Lesli::User.new(time_zone: "Europe/Berlin")
            @controller.define_singleton_method(:current_user) { user }
            Time.use_zone("UTC") do
                get :show
                assert_response :success
                assert_equal "15.01.2027 16:00", response.parsed_body.fetch("date")
                assert_equal "UTC", response.parsed_body.fetch("rails_zone")
                assert_equal "UTC", Time.zone.name
            end
        end

        test "anonymous users and users without a preference use the global fallback" do
            [nil, Lesli::User.new].each do |user|
                @controller.define_singleton_method(:current_user) { user }
                session[:time_zone] = "Asia/Tokyo" # Legacy session values are ignored.
                get :show
                assert_response :success
                assert_equal "15.01.2027 09:00", response.parsed_body.fetch("date")
            end
        end

        test "services and ERB views use Date2 in the profile zone" do
            user = Lesli::User.new(time_zone: "Europe/Berlin")
            @controller.define_singleton_method(:current_user) { user }
            get :detail
            assert_response :success
            assert_select "p", text: "15.01.2027 16:00"
            assert_select "time", text: "15.01.2027 16:00"
        end

        test "successive requests do not share a user's timezone" do
            Time.use_zone("UTC") do
                { "Europe/Berlin" => "16:00", "America/Guatemala" => "09:00", nil => "09:00" }.each do |zone, hour|
                    user = Lesli::User.new(time_zone: zone)
                    @controller.define_singleton_method(:current_user) { user }
                    get :show
                    assert_equal "15.01.2027 #{hour}", response.parsed_body.fetch("date")
                    assert_equal "UTC", Time.zone.name
                end
            end
        end

        test "works without a current_user method" do
            @controller.singleton_class.undef_method(:current_user) if @controller.respond_to?(:current_user, true)
            get :show
            assert_response :success
            assert_equal "15.01.2027 09:00", response.parsed_body.fetch("date")
        end

        test "restores the zone when a request raises an exception" do
            user = Lesli::User.new(time_zone: "Europe/Berlin")
            @controller.define_singleton_method(:current_user) { user }
            Time.use_zone("UTC") do
                assert_raises(RuntimeError) { get :failure }
                assert_equal "UTC", Time.zone.name
            end
        end
    end
end
