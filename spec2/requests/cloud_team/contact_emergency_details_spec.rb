require 'rails_helper'
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
RSpec.describe "ContactEmergencyDetails", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def find_account
        @account_id = CloudTeam::Account.find_by(id: @user.account.id)
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    describe "Testing Show" do

        it "Test json response" do
            
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com'
                }
            )

            employee.contact_emergency_detail = CloudTeam::Employee::ContactEmergencyDetail.create(
                full_name: Faker::Name.name,
                phone_number_1: Faker::Number.number(digits: 10), 
                phone_number_2: Faker::Number.number(digits: 10)
            )

            get "/team/employees/#{employee.id}/contact_emergency_detail.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "test invalid request (non-existent priority)" do
            login_admin            
            find_account

            get "/team/employees/#{Faker::Number.number(digits: 6)}/contact_emergency_detail.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

    describe "Testing Update" do

        it "Test json response" do
            
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com'
                }
            )

            employee.contact_emergency_detail = CloudTeam::Employee::ContactEmergencyDetail.create(
                full_name: Faker::Name.name,
                phone_number_1: Faker::Number.number(digits: 10), 
                phone_number_2: Faker::Number.number(digits: 10),
            )

            params = {
                :employee_contact_emergency_detail => {
                    full_name: Faker::Name.name,
                    phone_number_1: Faker::Number.number(digits: 10), 
                    phone_number_2: Faker::Number.number(digits: 10),
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{employee.id}/contact_emergency_detail", params: params, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end
        
        it "Test invalid request (unexistent priority)" do
            
            login_admin            
            find_account

            params = {
                :employee_contact_emergency_detail => {
                    full_name: Faker::Name.name,
                    phone_number_1: Faker::Number.number(digits: 10), 
                    phone_number_2: Faker::Number.number(digits: 10),
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{Faker::Number.number(digits: 10)}/contact_emergency_detail", params: params, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

end
