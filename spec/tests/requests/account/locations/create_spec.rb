=begin
Copyright (c) 2022, all rights reserved.
All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.
Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

require "lesli_request_helper"

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "POST:/administration/account/locations", type: :request do
        include_context "request user authentication"

        it "is expected to respond with a location created and parameters" do

            new_location_data = {
                :name => Faker::Nation.capital_city,
                :short_name => nil,
                :postal_code => nil,
                :latitude => nil,
                :longitude => nil,
                :code => nil,
                :level => "region",
                :native_level => nil,
                :parent_id => nil,
            }

            post("/administration/account/locations.json", params: {
                location: new_location_data
            })

            #share example
            expect_response_with_successful

            #validate data
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("name")
            expect(response_body["name"]).to be_a(String)
            expect(response_body["name"]).to eql(new_location_data[:name])

            expect(response_body).to have_key("short_name")
            expect(response_body["short_name"]).to be_nil
            expect(response_body["short_name"]).to eql(new_location_data[:short_name])

            expect(response_body).to have_key("postal_code")
            expect(response_body["postal_code"]).to be_nil
            expect(response_body["postal_code"]).to eql(new_location_data[:postal_code])

            expect(response_body).to have_key("latitude")
            expect(response_body["latitude"]).to be_nil
            expect(response_body["latitude"]).to eql(new_location_data[:latitude])

            expect(response_body).to have_key("longitude")
            expect(response_body["longitude"]).to be_nil
            expect(response_body["longitude"]).to eql(new_location_data[:longitude])

            expect(response_body).to have_key("code")
            expect(response_body["code"]).to be_nil
            expect(response_body["code"]).to eql(new_location_data[:code])

            expect(response_body).to have_key("level")
            expect(response_body["level"]).to be_a(String)
            expect(response_body["level"]).to eql(new_location_data[:level])

            expect(response_body).to have_key("native_level")
            expect(response_body["native_level"]).to be_nil
            expect(response_body["native_level"]).to eql(new_location_data[:native_level])

            expect(response_body).to have_key("parent_id")
            expect(response_body["parent_id"]).to be_nil
            expect(response_body["parent_id"]).to eql(new_location_data[:parent_id])

            expect(response_body).to have_key("deleted_at")
            expect(response_body["deleted_at"]).to be_nil

            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)

            expect(response_body).to have_key("updated_at")
            expect(response_body["updated_at"]).to be_a(String)

        end

        it "is expected to respond with an error response when the location hash does not have any key" do

            new_location_data = {}

            post("/administration/account/locations.json", params: {
                location: new_location_data
            })

            #share example
            expect_response_with_error
            
            #validate response
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

            expect(response_body).to have_key("details")
            expect(response_body["details"]).to be_a(Array)
        end


        it "is expected to respond with an error response when all params are nil" do

            new_location_data = {
                :name => nil,
                :level => nil,
            }

            post("/administration/account/locations.json", params: {
                location: new_location_data
            })

            #share example
            expect_response_with_error

            #validate response
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

            expect(response_body).to have_key("details")
            expect(response_body["details"]).to be_a(Array)
        end


        it "is expected to respond with an error response when all params are empty strings" do
            new_location_data = {
                :name => "",
                :level => "",
            }

            post("/administration/account/locations.json", params: {
                location: new_location_data
            })

            #share example
            expect_response_with_error

            #validate response
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

            expect(response_body).to have_key("details")
            expect(response_body["details"]).to be_a(Array)
        end
    end
end
