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
    describe "DELETE:/administration/account/settings/:id.json", type: :request do
        include_context "request user authentication"

        it "is expected to delete the inserted setting" do
            @setting = {
                name: "facts",
                value: Faker::ChuckNorris.fact,
            }
    
            @setting = @current_user.account.settings.create(@setting)
            delete("/administration/account/settings/#{@setting.id}.json")
            
            #share examples
            expect_response_with_successful

            #expect to do not have the settings inserted before
            expect(@current_user.account.settings.find_by_id(@setting.id).to_json).to eql("null")
            expect(response_body).to be_a(Hash)
        end 

        it "is expected to respond with error when id is invalid" do

            @invalid_id = @current_user.account.settings.last[:id] + 1
            delete("/administration/account/settings/#{@invalid_id}.json")
            
            #share examples
            expect_response_with_not_found
        end 
    end
end
