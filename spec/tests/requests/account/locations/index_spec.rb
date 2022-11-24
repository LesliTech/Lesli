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
    describe "GET:/administration/account/locations", type: :request do
        include_context "request user authentication"

        it "is expected to return with a list of locations created" do

            @data = {
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

            # Destroy all records in the DB
            @location = @current_user.account.locations.new(@data)
            @location.save!

            get("/administration/account/locations.json")

            #share example
            expect_response_with_successful

            #validate data
            expect(response_body.first).to be_a(Hash)

            expect(response_body.first).to have_key("id")
            expect(response_body.first["id"]).to be_a(Numeric)

            expect(response_body.first).to have_key("name")
            expect(response_body.first["name"]).to be_a(String)
            expect(response_body.first["name"]).to eql(@data[:name])

            expect(response_body.first).to have_key("short_name")
            expect(response_body.first["short_name"]).to be_nil
            expect(response_body.first["short_name"]).to eql(@data[:short_name])

            expect(response_body.first).to have_key("postal_code")
            expect(response_body.first["postal_code"]).to be_nil
            expect(response_body.first["postal_code"]).to eql(@data[:postal_code])

            expect(response_body.first).to have_key("latitude")
            expect(response_body.first["latitude"]).to be_nil
            expect(response_body.first["latitude"]).to eql(@data[:latitude])

            expect(response_body.first).to have_key("longitude")
            expect(response_body.first["longitude"]).to be_nil
            expect(response_body.first["longitude"]).to eql(@data[:longitude])

            expect(response_body.first).to have_key("code")
            expect(response_body.first["code"]).to be_nil
            expect(response_body.first["code"]).to eql(@data[:code])

            expect(response_body.first).to have_key("level")
            expect(response_body.first["level"]).to be_a(String)
            expect(response_body.first["level"]).to eql(@data[:level])

            expect(response_body.first).to have_key("native_level")
            expect(response_body.first["native_level"]).to be_nil
            expect(response_body.first["native_level"]).to eql(@data[:native_level])

            expect(response_body.first).to have_key("parent_id")
            expect(response_body.first["parent_id"]).to be_nil
            expect(response_body.first["parent_id"]).to eql(@data[:parent_id])

            expect(response_body.first).to have_key("deleted_at")
            expect(response_body.first["deleted_at"]).to be_nil

            expect(response_body.first).to have_key("created_at")
            expect(response_body.first["created_at"]).to be_a(String)

            expect(response_body.first).to have_key("updated_at")
            expect(response_body.first["updated_at"]).to be_a(String)

        end
    end
end

