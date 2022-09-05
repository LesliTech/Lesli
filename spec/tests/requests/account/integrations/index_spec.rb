=begin

Copyright (c) 2020, all rights reserved.

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


# include helpers, configuration & initializers for request tests
require "lesli_request_helper"

data = [
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
]

RSpec.describe "GET:/administration/account/integrations", type: :request, :unless => defined?(DeutscheLeibrenten) do

    include_context "request user authentication"

    it "is expected to respond with integrations" do 

        [
            { :name => Faker::Superhero.power },
            { :name => Faker::Superhero.power },
            { :name => Faker::Superhero.power },
            { :name => Faker::Superhero.power },
        ].each do |integration|
            post("/administration/account/integrations.json", :params => {
                :account_integration => integration
            })
        end

        get("/administration/account/integrations.json")

        expect_response_with_pagination
        puts "paginacion de integrations #{response_body}"
        expect(response_body).to be_an(Object)
        expect(response_body).to have_key("pagination")
        expect(response_body).to have_key("records")

        expect(response_body["records"][0]).to have_key("id")
        expect(response_body["records"][0]).to have_key("name")
        expect(response_body["records"][0]).to have_key("active")
        expect(response_body["records"][0]).to have_key("email")
        expect(response_body["records"][0]).to have_key("usage_count")
        expect(response_body["records"][0]).to have_key("created_at")
        expect(response_body["records"][0]).to have_key("expiration_at")
        expect(response_body["records"][0]).to have_key("creator_id")
        expect(response_body["records"][0]).to have_key("creator_name")

        expect(response_body["records"][0]["id"]).to be_a(Numeric)
        expect(response_body["records"][0]["creator_id"]).to eq(@current_user.id)
        expect(response_body["records"][0]["creator_name"]).to eq(@current_user.name)

    end

end
