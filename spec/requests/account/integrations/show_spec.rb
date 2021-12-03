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

data = { :name => Faker::Superhero.power }

RSpec.describe "GET:/administration/account/integrations", type: :request do

    include_context "user authentication"

    before(:all) do
        # Delete all records in the db to work with a clean table
        @user.account.integrations.destroy_all

        @new_integration = @user.account.integrations.new({name: data[:name]})

        @new_integration_user_email = data[:name]
        .downcase
        .gsub(/[^0-9A-Za-z\s\-\_]/, "")
        .gsub(/\s+/, "-")
        .concat("-", SecureRandom.hex(4), "@integrations")

        user = @user.account.users.find_or_create_by(email: @new_integration_user_email) do |user|
            user.category = "integration"
            user.active = true
            user.confirm
            user.user_roles.create({ role: ::Role.find_by(:name => "api") })
            user.save!
        end

        @new_integration.user_main = @user
        @new_integration.user = user
        @new_integration.save

        # create session
        @user_integration_session = user.sessions.create({
            :session_source => "dispatcher_standar_session",
            :last_used_at   => LC::Date.now
        })

        get "/administration/account/integrations/#{@new_integration.id}.json"

    end

    include_examples "successful standard json response"


    it "is expected to respond with an integration deleted successfully" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@new_integration.id)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eq(data[:name])

        expect(@response_body_data).to have_key("user_main")
        expect(@response_body_data["user_main"]).to be_a(Hash)
        expect(@response_body_data["user_main"]).to eql(JSON.parse(@user.to_json))

        expect(@response_body_data).to have_key("session")
        expect(@response_body_data["session"]).to be_a(Hash)
        expect(@response_body_data["session"]).to eql(JSON.parse(@user_integration_session.to_json))

    end

end


RSpec.describe "GET:/administration/account/integrations", type: :request do
    include_context "user authentication"

    before(:all) do
        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: data[:name]
            }
        })

        # get an id that does not exist in the db
        @invalid_id =  @user.account.integrations.all.order(id: :asc).last["id"].to_i + 1

        get "/administration/account/integrations/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to respond with error when an invalid id to show is given" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end
