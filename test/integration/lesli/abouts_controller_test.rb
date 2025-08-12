require "test_helper"

class LesliTestRandom < ActionDispatch::IntegrationTest
    include ResponseRequestHelper
end

module Lesli
    class AboutsControllerTest < LesliTestRandom
        
        test "should return the list of Lesli engines as json" do

            # 2. Make a GET request to the specified URL
            get "/lesli/about.json"

            # 3. Assertions
            # Check that the request was successful
            assert_response :success

            # Verify that the response content type is JSON
            assert_equal "application/json; charset=utf-8", @response.content_type
            expect_response_with_successful

            # Parse the JSON body of the response
            actual_json = JSON.parse(@response.body).first

            assert_kind_of(Hash, actual_json)

            assert_equal(actual_json['name'], Lesli.to_s)
            assert_equal(actual_json['code'], Lesli.to_s.underscore)
            assert_equal(actual_json['build'], Lesli::BUILD)
            assert_equal(actual_json['version'], Lesli::VERSION)
        end
    end
end
