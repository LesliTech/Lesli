=begin
Copyright (c) 2021, all rights reserved.

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
    describe "GET:/administration/account/locations/:id", type: :request do
        include_context "request user authentication"

        it "is expect to respond with a @location found and shown" do
            @new_location_data = {
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

            @location = @current_user.account.locations.new(@new_location_data)
            @location.save

            get "/administration/account/locations/#{@location.id}.json"

            #share example
            expect_response_with_successful

            #validate data
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("name")
            expect(response_body["name"]).to be_a(String)
            expect(response_body["name"]).to eql(@location[:name])

            expect(response_body).to have_key("short_name")
            expect(response_body["short_name"]).to be_nil
            expect(response_body["short_name"]).to eql(@location[:short_name])

            expect(response_body).to have_key("postal_code")
            expect(response_body["postal_code"]).to be_nil
            expect(response_body["postal_code"]).to eql(@location[:postal_code])

            expect(response_body).to have_key("latitude")
            expect(response_body["latitude"]).to be_nil
            expect(response_body["latitude"]).to eql(@location[:latitude])

            expect(response_body).to have_key("longitude")
            expect(response_body["longitude"]).to be_nil
            expect(response_body["longitude"]).to eql(@location[:longitude])

            expect(response_body).to have_key("code")
            expect(response_body["code"]).to be_nil
            expect(response_body["code"]).to eql(@location[:code])

            expect(response_body).to have_key("level")
            expect(response_body["level"]).to be_a(String)
            expect(response_body["level"]).to eql(@location[:level])

            expect(response_body).to have_key("native_level")
            expect(response_body["native_level"]).to be_nil
            expect(response_body["native_level"]).to eql(@location[:native_level])

            expect(response_body).to have_key("parent_id")
            expect(response_body["parent_id"]).to be_nil
            expect(response_body["parent_id"]).to eql(@location[:parent_id])

            expect(response_body).to have_key("deleted_at")
            expect(response_body["deleted_at"]).to be_nil

            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)

            expect(response_body).to have_key("updated_at")
            expect(response_body["updated_at"]).to be_a(String)
        end

        it "is expect to respond with not found when search invalid id" do

            @location_id = @current_user.account.locations.last.id

            get "/administration/account/locations/#{@location_id + 1}.json"

            #share example
            expect_response_with_not_found

            #validate response
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

        end
    end
end
