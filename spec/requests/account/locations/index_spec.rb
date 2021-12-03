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

RSpec.describe "GET:/administration/account/locations", type: :request do

    include_context "user authentication"

    before(:all) do

        @data = {
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

        # Destroy all records in the DB
        @location = @user.account.locations.new(@data)
        @location.save!

        get "/administration/account/locations.json?filters[type]=region"

    end

    include_examples "successful standard json response"

    it "is expected to return with a list of locations created" do

        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.length).to be > 0

        expect(@response_body_data.last).to be_a(Hash)

        expect(@response_body_data.last).to have_key("id")
        expect(@response_body_data.last["id"]).to be_a(Numeric)

        expect(@response_body_data.last).to have_key("name")
        expect(@response_body_data.last["name"]).to be_a(String)

        expect(@response_body_data.last).to have_key("short_name")
        expect(@response_body_data.last["short_name"]).to be_nil

        expect(@response_body_data.last).to have_key("postal_code")
        expect(@response_body_data.last["postal_code"]).to be_nil

        expect(@response_body_data.last).to have_key("latitude")
        expect(@response_body_data.last["latitude"]).to be_nil

        expect(@response_body_data.last).to have_key("longitude")
        expect(@response_body_data.last["longitude"]).to be_nil

        expect(@response_body_data.last).to have_key("code")
        expect(@response_body_data.last["code"]).to be_nil

        expect(@response_body_data.last).to have_key("calling_code")
        expect(@response_body_data.last["calling_code"]).to be_nil

        expect(@response_body_data.last).to have_key("level")
        expect(@response_body_data.last["level"]).to be_a(String)

        expect(@response_body_data.last).to have_key("native_level")
        expect(@response_body_data.last["native_level"]).to be_nil

        expect(@response_body_data.last).to have_key("parent_id")
        expect(@response_body_data.last["parent_id"]).to be_nil

        expect(@response_body_data.last).to have_key("deleted_at")
        expect(@response_body_data.last["deleted_at"]).to be_nil

        expect(@response_body_data.last).to have_key("created_at")
        expect(@response_body_data.last["created_at"]).to be_a(String)

        expect(@response_body_data.last).to have_key("updated_at")
        expect(@response_body_data.last["updated_at"]).to be_a(String)

        expect(@response_body_data.last).to have_key("accounts_id")
        expect(@response_body_data.last["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data.last["accounts_id"]).to eql(@user.account.id)

    end

end