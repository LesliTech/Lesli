require "test_helper"

module Lesli
    class WelcomePageTest < ActionController::TestCase
        tests AboutsController

        setup do
            @routes = ActionDispatch::Routing::RouteSet.new
            @routes.draw { get "/welcome", to: "lesli/abouts#welcome" }
        end

        test "renders the default welcome message" do
            get :welcome
            assert_response :success
            assert_select "h1#welcome-title", text: "Build better business software with Rails."
            assert_match "Your Lesli application is ready.", response.body
        end
    end
end
