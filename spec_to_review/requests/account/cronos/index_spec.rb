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

RSpec.describe "GET:/administration/account/cronos", type: :request do
    include_context "user authentication"

    before(:all) do
        # Destroy all records in the DB
        @user.account.cronos.destroy_all

        @cronos = [
            {
                :name => Faker::Lorem.word,
                :description => Faker::Lorem.paragraph,
                :minute => Time.now.min,
                :hour => Time.now.hour,
                :day_of_month => Time.now.day,
                :month => Time.now.month,
                :day_of_week => Time.now.wday,
            }
        ]

        @cronos.each do |crono|
            crono[:users_id] = @user.id
            @user.account.cronos.create!(crono)
        end

        get "/administration/account/cronos.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with a list of all cronos saved in the DB" do
        expect(@response_body_data).to be_an(Array)

        expect(@response_body_data.length).to eql(@cronos.length)
        expect(@response_body_data.last.keys).to contain_exactly(
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
            "created_at",
            "updated_at",
            "accounts_id",
            "users_id"
        )

        expect(@response_body_data.last["id"]).to be_a(Numeric)

        expect(@response_body_data.last["name"]).to be_a(String)
        expect(@response_body_data.last["name"]).to eql(@cronos[0][:name])

        expect(@response_body_data.last["description"]).to be_a(String)
        expect(@response_body_data.last["description"]).to eql(@cronos[0][:description])

        expect(@response_body_data.last["status"]).to be_nil

        expect(@response_body_data.last["engine"]).to be_nil

        expect(@response_body_data.last["rake"]).to be_nil

        expect(@response_body_data.last["minute"]).to be_a(Numeric)
        expect(@response_body_data.last["minute"]).to eql(@cronos[0][:minute])

        expect(@response_body_data.last["hour"]).to be_a(Numeric)
        expect(@response_body_data.last["hour"]).to eql(@cronos[0][:hour])

        expect(@response_body_data.last["day_of_month"]).to be_a(Numeric)
        expect(@response_body_data.last["day_of_month"]).to eql(@cronos[0][:day_of_month])

        expect(@response_body_data.last["month"]).to be_a(Numeric)
        expect(@response_body_data.last["month"]).to eql(@cronos[0][:month])

        expect(@response_body_data.last["day_of_week"]).to be_a(Numeric)
        expect(@response_body_data.last["day_of_week"]).to eql(@cronos[0][:day_of_week])

        expect(@response_body_data.last["deleted_at"]).to be_nil

        expect(@response_body_data.last["created_at"]).not_to be_nil

        expect(@response_body_data.last["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data.last["accounts_id"]).to eql(@user.account.id)

        expect(@response_body_data.last["users_id"]).to be_a(Numeric)
        expect(@response_body_data.last["users_id"]).to eql(@user.id)
    end
end