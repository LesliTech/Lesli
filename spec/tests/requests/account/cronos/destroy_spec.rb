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
    describe "DELETE:/administration/account/cronos/:id", type: :request do
        include_context "request user authentication"

        it "is expected to respond with a crono deleted successfully" do
            crono_params = {
                :name => Faker::Lorem.word,
                :description => Faker::Lorem.paragraph,
                :minute => Time.now.min,
                :hour => Time.now.hour,
                :day_of_month => Time.now.day,
                :month => Time.now.month,
                :day_of_week => Time.now.wday,
                :task_name =>  Faker::Lorem.word, 
                :engine_code => Faker::Lorem.word
            }

            crono = @current_user.account.cronos.new(crono_params)
            crono.save

            delete("/administration/account/cronos/#{crono.id}.json")
            
            #share examples
            expect_response_with_successful
        end


        it "is expected to return with not found" do
            crono_params = {
                :name => Faker::Lorem.word,
                :description => Faker::Lorem.paragraph,
                :minute => Time.now.min,
                :hour => Time.now.hour,
                :day_of_month => Time.now.day,
                :month => Time.now.month,
                :day_of_week => Time.now.wday,
                :task_name =>  Faker::Lorem.word, 
                :engine_code => Faker::Lorem.word
            }

            crono = @current_user.account.cronos.new(crono_params)
            crono.save
            last_crono_id = @current_user.account.cronos.last.id

            delete("/administration/account/cronos/#{last_crono_id + 1}.json")

            #share examples
            expect_response_with_not_found

            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)
        end
    end 
end
