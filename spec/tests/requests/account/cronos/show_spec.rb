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
    describe "GET:/administration/account/cronos/:id.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond with  created cronos information" do
            @current_user.account.cronos.destroy_all

            crono = @current_user.account.cronos.new({
                :name => Faker::Lorem.word,
                :description => Faker::Lorem.paragraph,
                :minute => Time.now.min,
                :hour => Time.now.hour,
                :day_of_month => Time.now.day,
                :month => Time.now.month,
                :day_of_week => Time.now.wday,
                :task_name =>  Faker::Lorem.word, 
                :engine_code => Faker::Lorem.word
            })
            crono.save
            
            get("/administration/account/cronos/#{crono.id}.json")

            #share examples
            expect_response_with_successful
    
            expect(response_body).to be_a(Hash)
            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("name")
            expect(response_body["name"]).to be_a(String)
            expect(response_body["name"]).to eql(crono[:name])

            expect(response_body).to have_key("description")
            expect(response_body["description"]).to be_a(String)
            expect(response_body["description"]).to eql(crono[:description])

            expect(response_body).to have_key("status")
            expect(response_body["status"]).to be_nil

            expect(response_body).to have_key("engine_code")
            expect(response_body["engine_code"]).to be_a(String)
            expect(response_body["engine_code"]).to eql(crono[:engine_code])

            expect(response_body).to have_key("task_name")
            expect(response_body["task_name"]).to be_a(String)
            expect(response_body["task_name"]).to eql(crono[:task_name])

            expect(response_body).to have_key("rake")
            expect(response_body["rake"]).to be_nil

            expect(response_body).to have_key("minute")
            expect(response_body["minute"]).to be_a(Numeric)
            expect(response_body["minute"]).to eql(crono[:minute])

            expect(response_body).to have_key("hour")
            expect(response_body["hour"]).to be_a(Numeric)
            expect(response_body["hour"]).to eql(crono[:hour])

            expect(response_body).to have_key("day_of_month")
            expect(response_body["day_of_month"]).to be_a(Numeric)
            expect(response_body["day_of_month"]).to eql(crono[:day_of_month])

            expect(response_body).to have_key("month")
            expect(response_body["month"]).to be_a(Numeric)
            expect(response_body["month"]).to eql(crono[:month])

            expect(response_body).to have_key("day_of_week")
            expect(response_body["day_of_week"]).to be_a(Numeric)
            expect(response_body["day_of_week"]).to eql(crono[:day_of_week])

            expect(response_body).to have_key("deleted_at")
            expect(response_body["deleted_at"]).to be_nil

            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)


            expect(response_body).to have_key("accounts_id")
            expect(response_body["accounts_id"]).to be_a(Numeric)
            expect(response_body["accounts_id"]).to eql(@current_user.account.id)

        end

        it "is expected to return with not found" do

            cronos = @current_user.account.cronos.all.with_deleted.order(:id)
            invalid_crono_id = cronos.empty? ? 1 : cronos.last["id"] + 1

            get ("/administration/account/cronos/#{invalid_crono_id}.json")

            #share examples
            expect_response_with_not_found

            expect(response_body).to be_a(Hash)
            expect(response_body.keys).to contain_exactly("message")
            expect(response_body["message"]).to be_a(String)

        end

    end
end
