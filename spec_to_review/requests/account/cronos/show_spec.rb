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

RSpec.describe "GET:/administration/account/cronos/:id", type: :request do
    include_context "user authentication"

    before(:all) do

        @account_crono = @user.account.cronos.create!({
            :name => Faker::Lorem.word,
            :description => Faker::Lorem.paragraph,
            :minute => Time.now.min,
            :hour => Time.now.hour,
            :day_of_month => Time.now.day,
            :month => Time.now.month,
            :day_of_week => Time.now.wday,
            :users_id => @user.id
        })

        get "/administration/account/cronos/#{@account_crono.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with a crono created successfully" do
        # PENDING, CONTROLLER IS NOT WORKING CORRECTLY
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@account_crono[:name])

        expect(@response_body_data).to have_key("description")
        expect(@response_body_data["description"]).to be_a(String)
        expect(@response_body_data["description"]).to eql(@account_crono[:description])

        expect(@response_body_data).to have_key("status")
        expect(@response_body_data["status"]).to be_nil

        expect(@response_body_data).to have_key("engine")
        expect(@response_body_data["engine"]).to be_nil

        expect(@response_body_data).to have_key("rake")
        expect(@response_body_data["rake"]).to be_nil

        expect(@response_body_data).to have_key("minute")
        expect(@response_body_data["minute"]).to be_a(Numeric)
        expect(@response_body_data["minute"]).to eql(@account_crono[:minute])

        expect(@response_body_data).to have_key("hour")
        expect(@response_body_data["hour"]).to be_a(Numeric)
        expect(@response_body_data["hour"]).to eql(@account_crono[:hour])

        expect(@response_body_data).to have_key("day_of_month")
        expect(@response_body_data["day_of_month"]).to be_a(Numeric)
        expect(@response_body_data["day_of_month"]).to eql(@account_crono[:day_of_month])

        expect(@response_body_data).to have_key("month")
        expect(@response_body_data["month"]).to be_a(Numeric)
        expect(@response_body_data["month"]).to eql(@account_crono[:month])

        expect(@response_body_data).to have_key("day_of_week")
        expect(@response_body_data["day_of_week"]).to be_a(Numeric)
        expect(@response_body_data["day_of_week"]).to eql(@account_crono[:day_of_week])

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data["accounts_id"]).to eql(@user.account.id)

        expect(@response_body_data).to have_key("users_id")
        expect(@response_body_data["users_id"]).to be_a(Numeric)
        expect(@response_body_data["users_id"]).to eql(@user.id)
    end
end

RSpec.describe "GET:/administration/account/cronos/:id", type: :request do
    include_context "user authentication"

    before(:all) do
        # Look for an ID that does not exist
        @cronos = @user.account.cronos.all.with_deleted.order(:id)
        @invalid_crono_id = @cronos.empty? ? 1 : @cronos.last["id"] + 1

        get "/administration/account/cronos/#{@invalid_crono_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to return with not found" do
        expect(@response_body).to be_a(Hash)

        expect(@response_body).to have_key("error")
        expect(@response_body["error"].keys).to contain_exactly("message", "details")

        expect(@response_body["error"]["message"]).to be_a(String)
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end