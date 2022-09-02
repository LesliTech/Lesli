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

        it "is expected to respond with error when params is empty" do
            post("/administration/account/cronos.json", params: {
            })

            #share examples
            expect_response_with_error
        end 

        it "is expected to respond with error when settings in params is empty" do
            post("/administration/account/cronos.json", params: {
                account_crono: {}
            })

            #share examples
            expect_response_with_error
        end 

        it "is expected to respond with a crono created successfully" do
            
            account_crono = {
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
            
            post("/administration/account/cronos.json", params: {
                account_crono: account_crono
            })

            #share examples
            expect_response_with_successful
    
            expect(response_body).to be_a(Hash)
            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("name")
            expect(response_body["name"]).to be_a(String)
            expect(response_body["name"]).to eql(account_crono[:name])

            expect(response_body).to have_key("description")
            expect(response_body["description"]).to be_a(String)
            expect(response_body["description"]).to eql(account_crono[:description])

            expect(response_body).to have_key("status")
            expect(response_body["status"]).to be_nil

            expect(response_body).to have_key("engine_code")
            expect(response_body["engine_code"]).to be_a(String)
            expect(response_body["engine_code"]).to eql(account_crono[:engine_code])

            expect(response_body).to have_key("task_name")
            expect(response_body["task_name"]).to be_a(String)
            expect(response_body["task_name"]).to eql(account_crono[:task_name])

            expect(response_body).to have_key("rake")
            expect(response_body["rake"]).to be_nil

            expect(response_body).to have_key("minute")
            expect(response_body["minute"]).to be_a(Numeric)
            expect(response_body["minute"]).to eql(account_crono[:minute])

            expect(response_body).to have_key("hour")
            expect(response_body["hour"]).to be_a(Numeric)
            expect(response_body["hour"]).to eql(account_crono[:hour])

            expect(response_body).to have_key("day_of_month")
            expect(response_body["day_of_month"]).to be_a(Numeric)
            expect(response_body["day_of_month"]).to eql(account_crono[:day_of_month])

            expect(response_body).to have_key("month")
            expect(response_body["month"]).to be_a(Numeric)
            expect(response_body["month"]).to eql(account_crono[:month])

            expect(response_body).to have_key("day_of_week")
            expect(response_body["day_of_week"]).to be_a(Numeric)
            expect(response_body["day_of_week"]).to eql(account_crono[:day_of_week])

            expect(response_body).to have_key("deleted_at")
            expect(response_body["deleted_at"]).to be_nil

            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)


            expect(response_body).to have_key("accounts_id")
            expect(response_body["accounts_id"]).to be_a(Numeric)
            expect(response_body["accounts_id"]).to eql(@current_user.account.id)

            expect(response_body).to have_key("users_id")
            expect(response_body["users_id"]).to be_a(Numeric)
            expect(response_body["users_id"]).to eql(@current_user.id)

        end

        it "is expected to respond with fail when params to create are empty" do
            
            account_crono = {
                :name => "",
                :description => "",
                :minute => "",
                :hour => "",
                :day_of_month => "",
                :month => "",
                :day_of_week => ""
            }

            post("/administration/account/cronos.json", params: {
                account_crono: account_crono
            })

            #share examples
            expect_response_with_error

            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

            expect(response_body).to have_key("details")
            expect(response_body["details"]).to be_an(Array)


        end

        it "is expected to respond with fail when params to create are nil or undefined" do
            
            account_crono = {
                :name => nil,
                :description => nil,
                :minute => nil,
                :hour => nil,
                :day_of_month => nil,
                :month => nil,
                :day_of_week => nil
            }

            post("/administration/account/cronos.json", params: {
                account_crono: account_crono
            })

            #share examples
            expect_response_with_error

            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

            expect(response_body).to have_key("details")
            expect(response_body["details"]).to be_an(Array)


        end
    end
end
