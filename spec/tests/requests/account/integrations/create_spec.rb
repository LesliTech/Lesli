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


RSpec.describe "POST:/administration/account/integrations", type: :request, :unless => defined?(DeutscheLeibrenten) do 

    include_context "request user authentication"

    it "is expected to respond with integrations created successfully" do
        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: Faker::Superhero.power
            }
        })
        expect_response_with_successful
        expect(response_body).to be_a(String)
        expect(response_body.length).to eq(20)
    end

    it "is expected to respond with error when params are nil" do

        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: nil
            }
        })

        expect_response_with_error

        expect(response_body).to have_key("message")
        expect(response_body["message"]).to be_a(String)

        expect(response_body).to have_key("details")
        expect(response_body["details"]).to be_a(Array)
    end

    it "is expected to respond with error when params are empty strings" do

        post("/administration/account/integrations.json", params: {
            account_integration: {
                name: ""
            }
        })

        expect_response_with_error

        expect(response_body).to have_key("message")
        expect(response_body["message"]).to be_a(String)

        expect(response_body).to have_key("details")
        expect(response_body["details"]).to be_a(Array)
    end

end
