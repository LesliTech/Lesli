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
    describe "GET:/administration/account/cronos.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond with a list of all cronos saved in the DB" do
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
            
            get("/administration/account/cronos.json")

            #share examples
            expect_response_with_successful
    
            expect(response_body.first).to be_a(Hash)
            expect(response_body.first).to have_key("id")
            expect(response_body.first["id"]).to be_a(Numeric)

            expect(response_body.first).to have_key("name")
            expect(response_body.first["name"]).to be_a(String)
            expect(response_body.first["name"]).to eql(crono[:name])

            expect(response_body.first).to have_key("description")
            expect(response_body.first["description"]).to be_a(String)
            expect(response_body.first["description"]).to eql(crono[:description])

            expect(response_body.first).to have_key("status")
            expect(response_body.first["status"]).to be_nil

            expect(response_body.first).to have_key("engine_code")
            expect(response_body.first["engine_code"]).to be_a(String)
            expect(response_body.first["engine_code"]).to eql(crono[:engine_code])

            expect(response_body.first).to have_key("task_name")
            expect(response_body.first["task_name"]).to be_a(String)
            expect(response_body.first["task_name"]).to eql(crono[:task_name])

            expect(response_body.first).to have_key("rake")
            expect(response_body.first["rake"]).to be_nil

            expect(response_body.first).to have_key("minute")
            expect(response_body.first["minute"]).to be_a(Numeric)
            expect(response_body.first["minute"]).to eql(crono[:minute])

            expect(response_body.first).to have_key("hour")
            expect(response_body.first["hour"]).to be_a(Numeric)
            expect(response_body.first["hour"]).to eql(crono[:hour])

            expect(response_body.first).to have_key("day_of_month")
            expect(response_body.first["day_of_month"]).to be_a(Numeric)
            expect(response_body.first["day_of_month"]).to eql(crono[:day_of_month])

            expect(response_body.first).to have_key("month")
            expect(response_body.first["month"]).to be_a(Numeric)
            expect(response_body.first["month"]).to eql(crono[:month])

            expect(response_body.first).to have_key("day_of_week")
            expect(response_body.first["day_of_week"]).to be_a(Numeric)
            expect(response_body.first["day_of_week"]).to eql(crono[:day_of_week])

            expect(response_body.first).to have_key("deleted_at")
            expect(response_body.first["deleted_at"]).to be_nil

            expect(response_body.first).to have_key("created_at")
            expect(response_body.first["created_at"]).to be_a(String)


            expect(response_body.first).to have_key("accounts_id")
            expect(response_body.first["accounts_id"]).to be_a(Numeric)
            expect(response_body.first["accounts_id"]).to eql(@current_user.account.id)

        end
    end
end
