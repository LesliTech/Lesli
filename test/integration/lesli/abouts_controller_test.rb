require "test_helper"

class LesliTestRandom < ActionDispatch::IntegrationTest
    include ResponseRequestHelper
end

module Lesli
    class AboutsControllerTest < LesliTestRandom
        
        test "should return the list of Lesli engines as json" do
            # 1. Define the expected JSON response
            expected_json ={
                "name" => "Lesli",
                "code" => "lesli",
                "path" => "/lesli",
                "build" => "1754919086",
                "version" => "5.0.21",
                "description" => "Lesli is a SaaS development framework designed to build highly scalable, secure and customizable software products."
            }

            # 2. Make a GET request to the specified URL
            get "/lesli/about.json"

            # 3. Assertions
            # Check that the request was successful
            assert_response :success

            # Verify that the response content type is JSON
            assert_equal "application/json; charset=utf-8", @response.content_type
            expect_response_with_successful(@response)

            # Parse the JSON body of the response
            actual_json = JSON.parse(@response.body).first

            # Compare the parsed JSON with the expected JSON
            assert_equal expected_json, actual_json
        end
    end
end
