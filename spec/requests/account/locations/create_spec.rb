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

require "rails_helper"
require "spec_helper"
require "byebug"

RSpec.describe "POST:/administration/account/locations", type: :request do

    include_context "user authentication"

    before(:all) do

        @new_location_data = {
            :name => Faker::Nation.capital_city,
            :short_name => nil,
            :postal_code => nil,
            :latitude => nil,
            :longitude => nil,
            :code => nil,
            :calling_code => nil,
            :level => "region",
            :native_level => nil,
            :parent_id => nil,
            :accounts_id => @user.account.id

        }

        post("/administration/account/locations.json", params: {
            location: @new_location_data
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with a location created" do

        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@new_location_data[:name])

        expect(@response_body_data).to have_key("short_name")
        expect(@response_body_data["short_name"]).to be_nil
        expect(@response_body_data["short_name"]).to eql(@new_location_data[:short_name])


        expect(@response_body_data).to have_key("postal_code")
        expect(@response_body_data["postal_code"]).to be_nil
        expect(@response_body_data["postal_code"]).to eql(@new_location_data[:postal_code])


        expect(@response_body_data).to have_key("latitude")
        expect(@response_body_data["latitude"]).to be_nil
        expect(@response_body_data["latitude"]).to eql(@new_location_data[:latitude])

        expect(@response_body_data).to have_key("longitude")
        expect(@response_body_data["longitude"]).to be_nil
        expect(@response_body_data["longitude"]).to eql(@new_location_data[:longitude])

        expect(@response_body_data).to have_key("code")
        expect(@response_body_data["code"]).to be_nil
        expect(@response_body_data["code"]).to eql(@new_location_data[:code])

        expect(@response_body_data).to have_key("calling_code")
        expect(@response_body_data["calling_code"]).to be_nil
        expect(@response_body_data["calling_code"]).to eql(@new_location_data[:calling_code])

        expect(@response_body_data).to have_key("level")
        expect(@response_body_data["level"]).to be_a(String)
        expect(@response_body_data["level"]).to eql(@new_location_data[:level])

        expect(@response_body_data).to have_key("native_level")
        expect(@response_body_data["native_level"]).to be_nil
        expect(@response_body_data["native_level"]).to eql(@new_location_data[:native_level])

        expect(@response_body_data).to have_key("parent_id")
        expect(@response_body_data["parent_id"]).to be_nil
        expect(@response_body_data["parent_id"]).to eql(@new_location_data[:parent_id])

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data["accounts_id"]).to eql(@new_location_data[:accounts_id])
    end

end

RSpec.describe "POST:/administration/account/locations" do

    include_context "user authentication"

    before(:all) do
        post("/administration/account/locations.json", params: {})
    end

    include_examples "error standard json response"

    it "is expected to respond with an error response when there are no parameters(location should exists)" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end

RSpec.describe "POST:/administration/account/locations" do

    include_context "user authentication"

    before(:all) do
        @new_location_data = {}

        post("/administration/account/locations.json", params: {
            location: @new_location_data
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with an error response when the location hash does not have any key" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end

end


RSpec.describe "POST:/administration/account/locations" do

    include_context "user authentication"

    before(:all) do
        @new_location_data = {
            :name => nil,
            :level => nil,
        }

        post("/administration/account/locations.json", params: {
            location: @new_location_data
        })

    end

    include_examples "error standard json response"

    it "is expected to respond with an error response when all params are nil" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end

end

RSpec.describe "POST:/administration/account/locations" do

    include_context "user authentication"

    before(:all) do
        @new_location_data = {
            :name => "",
            :level => "",
        }

        post("/administration/account/locations.json", params: {
            location: @new_location_data
        })

    end

    include_examples "error standard json response"

    it "is expected to respond with an error response when all params are empty strings" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end

end