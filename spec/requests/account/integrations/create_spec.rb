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

[
    {
        :name => Faker::Superhero.power
    },
    {
        :name => Faker::Superhero.power
    },
    {
        :name => Faker::Superhero.power
    }
].each do |integration|
    RSpec.describe "POST:/administration/account/integrations", type: :request do


        include_context "user authentication"

        before(:all) do
            post("/administration/account/integrations.json", params: {
                account_integration: {
                    name: integration[:name]
                },
                session: {
                    expiration_at: DateTime.new
                }
            })
        end

        include_examples "successful standard json response"

        it "is expected to respond with integrations created successfully" do
            expect(@response_body_data).to be_a(String)
        end
    end
end


RSpec.describe "POST:/administation/account/integrations", type: :request do

    include_context "user authentication"

    before(:all) do
        #  should assign a valid id, when id is nil or empty string is given
        @id = nil
        @name = Faker::Superhero.power

        post("/administration/account/integrations.json", params: {
            account_integration: {
                id: @id,
                name: @name
            },
            session: {
                expiration_at: DateTime.new
            }
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with a integration created successfully" do
        expect(@response_body_data).to be_a(String)
    end
end


RSpec.describe "POST:/administation/account/integrations", type: :request do

    include_context "user authentication"

    before(:all) do
        # params must be validated before being processed in the corresponding action method
        # so, if the params are nil, should return a error json response
        @name = nil

        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: @name
            },
            session: {
                expiration_at: DateTime.new
            }
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when params are nil" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end

RSpec.describe "POST:/administation/account/integrations", type: :request do

    include_context "user authentication"

    before(:all) do
        # params must be validated before being processed in the corresponding action method
        # so, if the params are empty strings, should return a error json response
        @name = ""

        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: @name
            },
            session: {
                expiration_at: DateTime.new
            }
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when params are empty strings" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end
