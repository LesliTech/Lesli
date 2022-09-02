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
    describe "POST:/administration/account/cronos.json", type: :request do
        include_context "request user authentication"

        account_crono = {
            :name => Faker::Lorem.word,
            :description => Faker::Lorem.paragraph,
            :minute => Time.now.min,
            :hour => Time.now.hour,
            :day_of_month => Time.now.day,
            :month => Time.now.month,
            :day_of_week => Time.now.wday
        }

        it "is expected to respond with error when params is empty" do
            post("/administration/account/settings.json", params: {
        })
        
            #share examples
            expect_response_with_error
        end 

        it "is expected to respond with a crono created successfully" do
            
            post("/administration/account/cronos.json", params: {
                account_crono: @account_crono
            })

            #share examples
            expect_response_with_successful
                
            puts "respuesta #{response_body}"

            expect(@response_body_data).to be_a(Hash)
            expect(@response_body_data).to have_key("id")
            expect(@response_body_data["id"]).to be_a(Numeric)

            expect(@response_body_data).to have_key("name")
            expect(@response_body_data["name"]).to be_a(String)
            expect(@response_body_data["name"]).to eql(@account_crono[:name])

            expect(@response_body_data).to have_key("description")
            expect(@response_body_data["description"]).to be_a(String)
            expect(@response_body_data["description"]).to eql(@account_crono[:description])

            expect(@response_body_data).to have_key("status")
            expect(@response_body_data["status"]).to be_nil

            expect(@response_body_data).to have_key("engine")
            expect(@response_body_data["engine"]).to be_nil

            expect(@response_body_data).to have_key("rake")
            expect(@response_body_data["rake"]).to be_nil

            expect(@response_body_data).to have_key("minute")
            expect(@response_body_data["minute"]).to be_a(Numeric)
            expect(@response_body_data["minute"]).to eql(@account_crono[:minute])

            expect(@response_body_data).to have_key("hour")
            expect(@response_body_data["hour"]).to be_a(Numeric)
            expect(@response_body_data["hour"]).to eql(@account_crono[:hour])

            expect(@response_body_data).to have_key("day_of_month")
            expect(@response_body_data["day_of_month"]).to be_a(Numeric)
            expect(@response_body_data["day_of_month"]).to eql(@account_crono[:day_of_month])

            expect(@response_body_data).to have_key("month")
            expect(@response_body_data["month"]).to be_a(Numeric)
            expect(@response_body_data["month"]).to eql(@account_crono[:month])

            expect(@response_body_data).to have_key("day_of_week")
            expect(@response_body_data["day_of_week"]).to be_a(Numeric)
            expect(@response_body_data["day_of_week"]).to eql(@account_crono[:day_of_week])

            expect(@response_body_data).to have_key("deleted_at")
            expect(@response_body_data["deleted_at"]).to be_nil

            expect(@response_body_data).to have_key("created_at")
            expect(@response_body_data["created_at"]).to be_a(String)


            expect(@response_body_data).to have_key("accounts_id")
            expect(@response_body_data["accounts_id"]).to be_a(Numeric)
            expect(@response_body_data["accounts_id"]).to eql(@user.account.id)

            expect(@response_body_data).to have_key("users_id")
            expect(@response_body_data["users_id"]).to be_a(Numeric)
            expect(@response_body_data["users_id"]).to eql(@user.id)
        end
=begin
    RSpec.describe "POST:/administration/account/cronos", type: :request do

        before(:all) do
            post("/administration/account/cronos.json", params: {
                account_crono: {
                    :name => "", # should not be empty or nil
                    :description => "",
                    :minute => nil, # should be a number
                    :hour => nil, # should be a number
                    :day_of_month => nil, # should be a number
                    :month => nil, # should be a number
                    :day_of_week => nil # should be a number
                }
            })
        end

        include_examples "error standard json response"

        it "is expected to respond with error when params are empty strings and nil" do
            expect(@response_body).to have_key("error")
            expect(@response_body["error"]).to be_a(Hash)

            expect(@response_body["error"]).to have_key("message")
            expect(@response_body["error"]["message"]).to be_a(String)

            expect(@response_body["error"]).to have_key("details")
            expect(@response_body["error"]["details"]).to be_a(Array)
        end
=end
    end
end
