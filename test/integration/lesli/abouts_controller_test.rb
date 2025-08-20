
require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class AboutsControllerTest < LesliIntegrationTester
        
        test "should return the list of lesli engines as json" do

            # Make a GET request to the specified URL
            get("/lesli/about.json")

            # Parse the JSON body of the response
            response_body = response_json.first


            # Verify that the response content type is JSON
            expect_response_with_successful()


            assert_equal(response_body['name'], Lesli.to_s)
            assert_equal(response_body['code'], Lesli.to_s.underscore)
            assert_equal(response_body['build'], Lesli::BUILD)
            assert_equal(response_body['version'], Lesli::VERSION)


            # custom specs
            assert_kind_of(Hash, response_body)
            assert_kind_of(Array, response_json)
            
            assert_operator(response_body.length, :>=, 1)
            assert_includes(response_body.keys, "name")
            assert_includes(response_body.keys, "code")
            assert_includes(response_body.keys, "path")
            assert_includes(response_body.keys, "build")
            assert_includes(response_body.keys, "version")
            assert_includes(response_body.keys, "description")

            assert_instance_of(String, response_body["name"])
            assert_instance_of(String, response_body["code"])
            assert_instance_of(String, response_body["path"])
            assert_instance_of(String, response_body["build"])
            assert_instance_of(String, response_body["version"])
            assert_instance_of(String, response_body["description"])

            assert_equal(Lesli.to_s, response_body["name"])
            assert_equal(Lesli.to_s.underscore, response_body["code"])
            assert_equal(Lesli::BUILD, response_body["build"])
            assert_equal(Lesli::VERSION, response_body["version"])
        end
    end
end
