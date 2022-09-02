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

RSpec.describe "GET:/administration/account/locations/:id", type: :request do

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

        @location = @user.account.locations.new(@new_location_data)
        @location.save

        get "/administration/account/locations/#{@location.id}.json"
    end

    include_examples "successful standard json response"

    it "is expect to respond with a location found and shown" do

        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@location.id)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@location[:name])

        expect(@response_body_data).to have_key("short_name")
        expect(@response_body_data["short_name"]).to be_nil
        expect(@response_body_data["short_name"]).to eql(@location[:short_name])


        expect(@response_body_data).to have_key("postal_code")
        expect(@response_body_data["postal_code"]).to be_nil
        expect(@response_body_data["postal_code"]).to eql(@location[:postal_code])


        expect(@response_body_data).to have_key("latitude")
        expect(@response_body_data["latitude"]).to be_nil
        expect(@response_body_data["latitude"]).to eql(@location[:latitude])

        expect(@response_body_data).to have_key("longitude")
        expect(@response_body_data["longitude"]).to be_nil
        expect(@response_body_data["longitude"]).to eql(@location[:longitude])

        expect(@response_body_data).to have_key("code")
        expect(@response_body_data["code"]).to be_nil
        expect(@response_body_data["code"]).to eql(@location[:code])

        expect(@response_body_data).to have_key("calling_code")
        expect(@response_body_data["calling_code"]).to be_nil
        expect(@response_body_data["calling_code"]).to eql(@location[:calling_code])

        expect(@response_body_data).to have_key("level")
        expect(@response_body_data["level"]).to be_a(String)
        expect(@response_body_data["level"]).to eql(@location[:level])

        expect(@response_body_data).to have_key("native_level")
        expect(@response_body_data["native_level"]).to be_nil
        expect(@response_body_data["native_level"]).to eql(@location[:native_level])

        expect(@response_body_data).to have_key("parent_id")
        expect(@response_body_data["parent_id"]).to be_nil
        expect(@response_body_data["parent_id"]).to eql(@location[:parent_id])

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data["accounts_id"]).to eql(@location[:accounts_id])

    end
end