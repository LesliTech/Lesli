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


RSpec.describe "POST:/administration/account/settings", type: :request do

    include_context "user authentication"

    before(:all) do

        @settings = {
            :color => Faker::Color.hex_color,
        }

        post("/administration/account/settings.json", params: {
            settings: @settings
        })

    end

    include_examples "successful standard json response"

    it "is expected to respond with nil" do
        expect(@response_body_data).to be_nil
    end

end

RSpec.describe "POST:/administration/account/settings", type: :request do

    include_context "user authentication"

    before(:all) do
        post("/administration/account/settings.json", params: {
            settings: {}
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
