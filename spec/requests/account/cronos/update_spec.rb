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

require 'lesli_request_helper'

RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do
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

        @new_data = {
            :name => Faker::Lorem.word,
            :description => Faker::Lorem.paragraph
        }

        patch("/administration/account/cronos/#{@account_crono.id}.json", params: {
            account_crono: @new_data
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with a crono updated with the verb PATCH" do
        expect(@response_body).to be_a(Hash)
        expect(@response_body["data"].keys).to contain_exactly(
            "id",
            "name",
            "description",
            "status",
            "engine",
            "rake",
            "minute",
            "hour",
            "day_of_month",
            "month",
            "day_of_week",
            "deleted_at",
            "accounts_id",
            "users_id",
            "created_at",
            "updated_at"
        )

        # Is expected to have been updated
        @new_data.each do |key, value|
            expect(@response_body["data"][key.to_s]).to eql(value)
        end
    end
end

RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do
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

        patch("/administration/account/cronos/#{@account_crono.id}.json", params: {
            account_crono: {
                :name => "", # should not be empty or nil
                :description => "",
                :minute => nil, # should be a number
                :hour => nil, # should be a number
                :day_of_month => nil, # should be a number
                :month => nil, # should be a number
                :day_of_week => nil # should be a number
            }
        })
    end

    include_examples "error standard json response"

    it "is expected to return with error when params are not sent" do
        expect(@response_body).to be_a(Hash)

        expect(@response_body).to have_key("error")
        expect(@response_body["error"].keys).to contain_exactly("message", "details")

        expect(@response_body["error"]["message"]).to be_a(String)
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end


RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do
    include_context "user authentication"

    before(:all) do
        @cronos = @user.account.cronos
        @invalid_crono_id = @cronos.length + 1

        patch("/administration/account/cronos/#{@invalid_crono_id}.json", params: {
            account_crono: {}
        })
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