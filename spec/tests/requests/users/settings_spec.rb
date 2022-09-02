=begin

Copyright (c) 2022, all rights reserved.

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

require "lesli_request_helper"

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/users/:user_id/settings.json", type: :request do
        include_context "request user authentication"

        # helper methods
        let!(:create_user) { FactoryBot.create(:user, role_name: "limited") }

        it "is expected to post a new language setting" do

            language_settings = { 
                name: 'locale', 
                value: "es"
            }

            @test_user = create_user
            post("/administration/users/#{@test_user.id}/settings.json", params: {
                user_setting: language_settings
            })

            #share examples
            expect_response_with_successful

            expect(response_body["value"]).to eql(language_settings[:value])
        end 
    end
end
