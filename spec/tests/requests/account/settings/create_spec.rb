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
    describe "GET:/administration/account/settings.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond with error when params is empty" do
            post("/administration/account/settings.json", params: {
            })

            #share examples
            expect_response_with_error
        end 

        
        it "is expected to respond with error when settings in params is empty" do
            post("/administration/account/settings.json", params: {
                settings: {}
            })

            #share examples
            expect_response_with_error
        end 

        it "is expected to respond with succesful with settings value nil" do
            post("/administration/account/settings.json", params: {
                settings: {:theme => nil}
            })

            #share examples
            expect_response_with_successful

            #verify if the setting sent was correctly save
            expect(@current_user.account.settings.find_by(name: "theme")["value"]).to be_nil
        end 

        it "is expected to respond with succesful set/create settings" do
            @settings = {
                :last_name => Faker::Name.name,
                :job => Faker::Job.title    
            }
            
            post("/administration/account/settings.json", params: {
                settings: @settings
            })

            #share examples
            expect_response_with_successful

            #verify if the setting sent was correctly save
            expect(@current_user.account.settings.find_by(name: "last_name")["value"]).to eql(@settings[:last_name])
            expect(@current_user.account.settings.find_by(name: "job")["value"]).to eql(@settings[:job])
        end
    end
end