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
RSpec.describe "SocialAccounts", type: :request do
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

    describe "Testing Index" do

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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            get "/team/employees/#{employee.id}/social_accounts.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "Test invalid request (non-existent priority)" do
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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            get "/team/employees/#{Faker::Number.number(digits: 10)}/social_accounts.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful" => false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

    describe "Testing Create" do

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

            params = {
                :employee_social_account => {
                    username: Faker::Name.name,
                    platform_id: 'facebook',
                }
            }.to_json
            headers = json_headers

            post "/team/employees/#{employee.id}/social_accounts", params: params, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "Test invalid request (unexistent priority)" do
            login_admin
            find_account

            params = {
                :employee_social_account => {
                    username: Faker::Name.name,
                    platform_id: 'facebook'
                }
            }.to_json
            headers = json_headers

            post "/team/employees/#{Faker::Number.number(digits: 10)}/social_accounts", params: params, headers: headers
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

        it "Test json response"do
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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            params = {
                :employee_social_account => {
                    username: Faker::Name.name,
                    platform_id: 'facebook',
                    cloud_team_employees_id: employee.id
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{employee.id}/social_accounts/#{employee_social_account.id}", params: params, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")

        end

        it "Test invalid request (unexistent priority)"do
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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            params = {
                :employee_social_account => {
                    username: Faker::Name.name,
                    platform_id: 'facebook',
                    cloud_team_employees_id: employee.id
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{Faker::Number.number(digits: 10)}/social_accounts/#{Faker::Number.number(digits: 10)}", params: params, headers: headers
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

    describe "Testing Destroy" do

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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                id: 10,
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            delete "/team/employees/#{employee.id}/social_accounts/#{employee_social_account.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "Test invalid" do
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

            employee_social_account = CloudTeam::Employee::SocialAccount.create!(
                id: 10,
                username: Faker::Name.name,
                platform_id: 'facebook',
                cloud_team_employees_id: employee.id
            )

            delete "/team/employees/#{employee.id}/social_accounts/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

    end

    describe "Testing social_account_options" do

        it "Testing response" do

            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com',
                    gender: 'Male'
                }
            )

            get '/team/options/social_accounts'
            response_json = JSON.parse(response.body)
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful" => true,
                "data" => {
                    "facebook"=>0, "instagram"=>1, 
                    "linkedin"=>5, "skype"=>3, 
                    "slack"=>2, "twitter"=>4}
            })

        end

    end


end
